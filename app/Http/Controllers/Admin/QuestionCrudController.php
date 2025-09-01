<?php
/**
 * File name: QuestionCrudController.php
 * Last modified: 19/07/21, 12:55 AM
 * Author: NearCraft - https://codecanyon.net/user/nearcraft
 * Copyright (c) 2021
 */

namespace App\Http\Controllers\Admin;

use App\Filters\QuestionFilters;
use App\Http\Controllers\Controller;
use App\Http\Requests\Admin\QuestionAttachmentRequest;
use App\Http\Requests\Admin\QuestionSettingsRequest;
use App\Http\Requests\Admin\QuestionSolutionRequest;
use App\Http\Requests\Admin\StoreQuestionRequest;
use App\Http\Requests\Admin\UpdateQuestionRequest;
use App\Models\ComprehensionPassage;
use App\Models\DifficultyLevel;
use App\Models\Question;
use App\Models\QuestionType;
use App\Models\Skill;
use App\Models\Tag;
use App\Models\Topic;
use App\Repositories\QuestionRepository;
use App\Repositories\TagRepository;
use App\Transformers\Admin\QuestionPreviewTransformer;
use App\Transformers\Admin\QuestionTransformer;
use App\Transformers\Admin\SkillSearchTransformer;
use App\Transformers\Admin\TopicSearchTransformer;
use Exception;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Gate;
use Illuminate\Support\Facades\Log;
use Inertia\Inertia;

class QuestionCrudController extends Controller
{
    private QuestionRepository $repository;

    public function __construct(QuestionRepository $repository)
    {
        $this->middleware(['role:admin|instructor']);
        $this->middleware('throttle:60,1')->only([
            'store', 'update', 'destroy', 'updateSettings', 'updateSolution', 'updateAttachment'
        ]);
        $this->repository = $repository;
    }

    /**
     * List all questions
     *
     * @param QuestionFilters $filters
     * @return \Inertia\Response
     */
    public function index(QuestionFilters $filters)
    {
        return Inertia::render('Admin/Questions', [
            'questionTypes' => QuestionType::select(['id as value', 'code', 'name as text'])->active()->get(),
            'questions' => function () use ($filters) {
                $query = Question::filter($filters)
                    ->with(['questionType:id,name,code', 'skill:id,name', 'topic:id,name', 'difficultyLevel:id,name'])
                    ->orderBy('id', 'desc');

                return fractal(
                    Cache::remember('questions:'.md5(json_encode(request()->all())), 60, function () use ($query) {
                        return $query->paginate(request('perPage', 10));
                    }),
                    new QuestionTransformer()
                )->toArray();
            },
        ]);
    }

    /**
     * Create a question
     *
     * @return \Inertia\Response
     */
    public function create()
    {
        // Select MSA as default question type if no question type specified
        if (request()->has('question_type')) {
            $questionType = QuestionType::select(['id', 'code', 'name'])
                ->where('code', request()->get('question_type'))
                ->firstOrFail();
        } else {
            $questionType = QuestionType::select(['id', 'code', 'name'])->first();
        }

        return Inertia::render('Admin/Question/Details', [
            'steps' => $this->repository->getSteps(),
            'questionType' => $questionType,
            'initialOptions' => $this->repository->setDefaultOptions($questionType->code),
            'initialAnswers' => $this->repository->setDefaultAnswers($questionType->code),
            'initialPreferences' => $this->repository->setDefaultPreferences($questionType->code)
        ]);
    }

    /**
     * Store a question
     *
     * @param StoreQuestionRequest $request
     * @return \Illuminate\Http\RedirectResponse
     */
    public function store(StoreQuestionRequest $request)
    {
        try {
            $question = new Question();
            $question->question = $request->question;
            $question->question_type_id = $request->question_type_id;
            $question->options = $request->options;
            $question->correct_answer = $request->question_type_id == 7 ? getBlankItems($request->question) : $request->correct_answer;
            $question->skill_id = $request->skill_id;
            $question->preferences = $request->preferences;
            $question->save();

            Log::info('Question created successfully', ['question_id' => $question->id]);

            return redirect()->route('question_settings', ['id' => $question->id])->with('successMessage', 'Details saved successfully!');
        } catch (Exception $e) {
            Log::error('Error storing question', ['error' => $e->getMessage()]);
            return redirect()->back()->with('errorMessage', 'An error occurred while saving the question.');
        }
    }

    /**
     * Show a question
     *
     * @param $id
     * @return \Illuminate\Http\JsonResponse
     */
    public function show($id)
    {
        $question = Question::with(['questionType:id,name,code', 'difficultyLevel:id,name,code', 'skill:id,name'])->findOrFail($id);
        return response()->json(fractal($question, new QuestionPreviewTransformer())->toArray()['data'], 200);
    }

    /**
     * Edit a question
     *
     * @param $id
     * @return \Inertia\Response
     */
    public function edit($id)
    {
        $question = Question::with('questionType')->findOrFail($id);
        return Inertia::render('Admin/Question/Details', [
            'steps' => $this->repository->getSteps($question->id, 'details'),
            'questionType' => $question->questionType,
            'question' => $question,
            'editFlag' => true,
            'questionId' => $question->id,
        ]);
    }

    /**
     * Update a question
     *
     * @param UpdateQuestionRequest $request
     * @param $id
     * @return \Illuminate\Http\RedirectResponse
     */
    public function update(UpdateQuestionRequest $request, $id)
    {
        try {
            $question = Question::findOrFail($id);
            $question->question = $request->question;
            $question->question_type_id = $request->question_type_id;
            $question->options = $request->options;
            $question->correct_answer = $request->question_type_id == 7 ? getBlankItems($request->question) : $request->correct_answer;
            $question->preferences = $request->preferences;
            $question->update();

            Log::info('Question updated successfully', ['question_id' => $question->id]);

            return redirect()->route('question_settings', ['id' => $question->id])->with('successMessage', 'Details saved successfully!');
        } catch (Exception $e) {
            Log::error('Error updating question', ['error' => $e->getMessage()]);
            return redirect()->back()->with('errorMessage', 'An error occurred while updating the question.');
        }
    }

    /**
     * Question settings page
     *
     * @param $id
     * @return \Inertia\Response
     */
    public function settings($id)
    {
        $question = Question::with(['tags', 'questionType', 'skill.section', 'topic.skill'])->findOrFail($id);

        return Inertia::render('Admin/Question/Settings', [
            'steps' => $this->repository->getSteps($question->id, 'settings'),
            'question' => $question,
            'questionType' => $question->questionType,
            'editFlag' => true,
            'questionId' => $question->id,
            'difficultyLevels' => Cache::remember('difficulty_levels', 3600, function () {
                return DifficultyLevel::select(['name', 'id'])->get();
            }),
            'initialSkills' => fractal(collect([$question->skill]), new SkillSearchTransformer())->toArray()['data'],
            'initialTopics' => fractal(collect([$question->topic]), new TopicSearchTransformer())->toArray()['data'],
            'initialTags' => Cache::remember('tags', 3600, function () {
                return Tag::select(['id', 'name'])->get();
            }),
        ]);
    }

    /**
     * Update question settings
     *
     * @param QuestionSettingsRequest $request
     * @param $id
     * @param TagRepository $tagRepository
     * @return \Illuminate\Http\RedirectResponse
     */
    public function updateSettings(QuestionSettingsRequest $request, $id, TagRepository $tagRepository)
    {
        try {
            $question = Question::findOrFail($id);
            $question->skill_id = $request->skill_id;
            $question->topic_id = $request->topic_id;
            $question->difficulty_level_id = $request->difficulty_level_id;
            $question->default_marks = $request->default_marks;
            $question->default_time = $request->default_time;
            $question->update();

            // Check if tags exists, otherwise create
            $tagRepository->createIfNotExists($request->tags);

            $tagData = Tag::whereIn('name', $request->tags)->pluck('id');
            $question->tags()->sync($tagData);

            Log::info('Question settings updated successfully', ['question_id' => $question->id]);

            return redirect()->route('question_solution', ['id' => $question->id])->with('successMessage', 'Settings saved successfully!');
        } catch (Exception $e) {
            Log::error('Error updating question settings', ['error' => $e->getMessage()]);
            return redirect()->back()->with('errorMessage', 'An error occurred while updating settings.');
        }
    }

    /**
     * Question solution page
     *
     * @param $id
     * @return \Inertia\Response
     */
    public function solution($id)
    {
        $question = Question::with('questionType')->findOrFail($id);
        return Inertia::render('Admin/Question/Solution', [
            'steps' => $this->repository->getSteps($question->id, 'solution'),
            'questionType' => $question->questionType,
            'question' => $question,
            'editFlag' => true,
            'questionId' => $question->id,
        ]);
    }

    /**
     * Update question solution
     *
     * @param QuestionSolutionRequest $request
     * @param $id
     * @return \Illuminate\Http\RedirectResponse
     */
    public function updateSolution(QuestionSolutionRequest $request, $id)
    {
        try {
            $question = Question::findOrFail($id);
            $question->hint = $request->hint;
            $question->solution = $request->solution;
            $question->solution_video = $request->solution_has_video ? $request->solution_video : null;
            $question->update();

            Log::info('Question solution updated successfully', ['question_id' => $question->id]);

            return redirect()->route('question_attachment', ['id' => $question->id])->with('successMessage', 'Solution updated successfully!');
        } catch (Exception $e) {
            Log::error('Error updating question solution', ['error' => $e->getMessage()]);
            return redirect()->back()->with('errorMessage', 'An error occurred while updating the solution.');
        }
    }

    /**
     * Question attachment page
     *
     * @param $id
     * @return \Inertia\Response
     */
    public function attachment($id)
    {
        $question = Question::with('questionType')->findOrFail($id);
        return Inertia::render('Admin/Question/Attachment', [
            'steps' => $this->repository->getSteps($question->id, 'attachment'),
            'questionType' => $question->questionType,
            'question' => $question,
            'editFlag' => true,
            'questionId' => $question->id,
            'initialComprehensions' => ComprehensionPassage::where('id', $question->comprehension_passage_id)->get()
        ]);
    }

    /**
     * Update question attachment
     *
     * @param QuestionAttachmentRequest $request
     * @param $id
     * @return \Illuminate\Http\RedirectResponse
     */
    public function updateAttachment(QuestionAttachmentRequest $request, $id)
    {
        try {
            $question = Question::findOrFail($id);
            $question->has_attachment = $request->has_attachment;
            $question->attachment_type = $request->attachment_type;
            $question->comprehension_passage_id = $request->attachment_type == 'comprehension' ? $request->comprehension_id : null;
            $question->attachment_options = $request->attachment_type == 'comprehension' ? null : $request->attachment_options;
            $question->update();

            Log::info('Question attachment updated successfully', ['question_id' => $question->id]);

            return redirect()->route('questions.index')->with('successMessage', 'Attachment successfully updated!');
        } catch (Exception $e) {
            Log::error('Error updating question attachment', ['error' => $e->getMessage()]);
            return redirect()->back()->with('errorMessage', 'An error occurred while updating the attachment.');
        }
    }

    /**
     * Delete a question
     *
     * @param $id
     * @return \Illuminate\Http\RedirectResponse
     */
    public function destroy($id)
    {
        try {
            $question = Question::withCount(['practiceSets', 'quizzes', 'exams'])->findOrFail($id);

            if (!$question->canSecureDelete('practiceSets', 'quizzes', 'exams')) {
                $associations = implode(", ", array_filter([
                    $question->quizzes_count > 0 ? "{$question->quizzes_count} quizzes" : "",
                    $question->exams_count > 0 ? "{$question->exams_count} exams" : "",
                    $question->practice_sets_count > 0 ? "{$question->practice_sets_count} practice sets" : ""
                ]));
                return redirect()->back()
                    ->with('errorMessage',
                        "Unable to delete question as it is associated with {$associations}. Remove all associations and try again!"
                    );
            }

            DB::transaction(function () use ($question) {
                $question->secureDelete('practiceSets', 'quizzes', 'exams', 'practiceSessions', 'quizSessions', 'examSessions');
            });

            Log::info('Question deleted successfully', ['question_id' => $id]);
        } catch (Exception $e) {
            Log::error('Error deleting question', ['error' => $e->getMessage()]);
            return redirect()->back()->with('errorMessage', 'Unable to Delete Question. Remove all associations and Try again!');
        }
        return redirect()->back()->with('successMessage', 'Question was successfully deleted!');
    }
}
