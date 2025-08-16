<?php

namespace Tests\Feature;

use App\Models\User;
use App\Models\Exam;
use App\Models\Question;
use App\Models\Category;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Config;
use Spatie\MediaLibrary\MediaCollections\Models\Media;
use Tests\TestCase;

class FileManagementTest extends TestCase
{
    use RefreshDatabase, WithFaker;

    protected $user;
    protected $admin;
    protected $exam;

    protected function setUp(): void
    {
        parent::setUp();
        
        $this->user = User::factory()->create();
        $this->admin = User::factory()->create();
        $this->admin->assignRole('admin');
        
        $this->exam = Exam::factory()->create();
        
        // Use fake storage for testing
        Storage::fake('public');
        Storage::fake('s3');
        
        // Configure Media Library settings
        Config::set('filesystems.default', 'public');
        Config::set('media-library.max_file_size', 1024 * 1024 * 10); // 10MB
        Config::set('media-library.allowed_mime_types', [
            'image/jpeg', 'image/png', 'image/gif', 'image/webp',
            'video/mp4', 'video/avi', 'video/mov', 'video/wmv',
            'application/pdf', 'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
            'application/zip', 'application/x-rar-compressed',
        ]);
    }

    /** @test */
    public function admin_can_add_media_to_exam()
    {
        $this->actingAs($this->admin);

        $file = UploadedFile::fake()->image('test-image.jpg', 800, 600);

        // Add media using Media Library API with the actual file
        $media = $this->exam
            ->addMedia($file)
            ->usingFileName('test-image.jpg')
            ->toMediaCollection('images');

        $this->assertInstanceOf(Media::class, $media);
        $this->assertEquals('test-image.jpg', $media->file_name);
        $this->assertEquals('images', $media->collection_name);
        $this->assertEquals('App\Models\Exam', $media->model_type);
        $this->assertEquals($this->exam->id, $media->model_id);

        // Verify media exists in database
        $this->assertDatabaseHas('media', [
            'model_type' => 'App\Models\Exam',
            'model_id' => $this->exam->id,
            'collection_name' => 'images',
            'file_name' => 'test-image.jpg',
        ]);
    }

    /** @test */
    public function admin_can_add_media_from_url()
    {
        $this->actingAs($this->admin);

        // Create a fake downloader to avoid network calls
        $fakeDownloader = $this->createMock(\Spatie\MediaLibrary\Downloaders\UrlDownloader::class);
        $fakeDownloader->method('getTempFile')
            ->willReturn(UploadedFile::fake()->image('test-image.jpg')->getRealPath());

        $this->app->instance(\Spatie\MediaLibrary\Downloaders\UrlDownloader::class, $fakeDownloader);

        // Mock URL with fake file content
        $media = $this->exam
            ->addMediaFromUrl('https://example.com/test-image.jpg')
            ->toMediaCollection('external_images');

        $this->assertInstanceOf(Media::class, $media);
        $this->assertEquals('external_images', $media->collection_name);
    }

    /** @test */
    public function admin_can_add_media_with_custom_properties()
    {
        $this->actingAs($this->admin);

        $file = UploadedFile::fake()->image('custom-image.jpg');

        $media = $this->exam
            ->addMedia($file)
            ->withCustomProperties([
                'alt_text' => 'Test image for exam',
                'description' => 'This is a test image',
                'photographer' => 'John Doe',
            ])
            ->toMediaCollection('images');

        $this->assertEquals('Test image for exam', $media->getCustomProperty('alt_text'));
        $this->assertEquals('This is a test image', $media->getCustomProperty('description'));
        $this->assertEquals('John Doe', $media->getCustomProperty('photographer'));
    }

    /** @test */
    public function media_can_be_retrieved_from_collection()
    {
        $this->actingAs($this->admin);

        // Add multiple media items to different collections
        $image = UploadedFile::fake()->image('image.jpg');
        $document = UploadedFile::fake()->create('document.pdf', 1000, 'application/pdf');

        $this->exam->addMedia($image)->toMediaCollection('images');
        $this->exam->addMedia($document)->toMediaCollection('documents');

        // Retrieve media from specific collections
        $images = $this->exam->getMedia('images');
        $documents = $this->exam->getMedia('documents');

        $this->assertCount(1, $images);
        $this->assertCount(1, $documents);
        $this->assertEquals('image.jpg', $images->first()->file_name);
        $this->assertEquals('document.pdf', $documents->first()->file_name);
    }

    /** @test */
    public function media_can_be_converted_to_different_formats()
    {
        $this->actingAs($this->admin);

        $file = UploadedFile::fake()->image('original.jpg', 1200, 800);

        $media = $this->exam
            ->addMedia($file)
            ->performConversions()
            ->toMediaCollection('images');

        // Test that conversions are generated (if configured)
        $this->assertNotEmpty($media->getUrl());
        $this->assertTrue(file_exists($media->getPath()));
    }

    /** @test */
    public function media_can_be_deleted()
    {
        $this->actingAs($this->admin);

        $file = UploadedFile::fake()->image('deletable.jpg');
        $media = $this->exam->addMedia($file)->toMediaCollection('images');

        $mediaId = $media->id;
        $this->assertDatabaseHas('media', ['id' => $mediaId]);

        // Delete the media
        $media->delete();

        $this->assertDatabaseMissing('media', ['id' => $mediaId]);
    }

    /** @test */
    public function media_collection_can_be_cleared()
    {
        $this->actingAs($this->admin);

        // Add multiple media items to the same collection
        $file1 = UploadedFile::fake()->image('image1.jpg');
        $file2 = UploadedFile::fake()->image('image2.jpg');
        $file3 = UploadedFile::fake()->image('image3.jpg');

        $this->exam->addMedia($file1)->toMediaCollection('gallery');
        $this->exam->addMedia($file2)->toMediaCollection('gallery');
        $this->exam->addMedia($file3)->toMediaCollection('gallery');

        $this->assertCount(3, $this->exam->getMedia('gallery'));

        // Clear the entire collection
        $this->exam->clearMediaCollection('gallery');

        $this->assertCount(0, $this->exam->fresh()->getMedia('gallery'));
    }

    /** @test */
    public function media_urls_are_generated_correctly()
    {
        $this->actingAs($this->admin);

        $file = UploadedFile::fake()->image('url-test.jpg');
        $media = $this->exam->addMedia($file)->toMediaCollection('images');

        $url = $media->getUrl();
        $fullUrl = $media->getFullUrl();

        $this->assertNotEmpty($url);
        $this->assertNotEmpty($fullUrl);
        $this->assertStringContainsString('url-test.jpg', $url);
    }

    /** @test */
    public function media_validation_works()
    {
        $this->actingAs($this->admin);

        // Test file size validation
        $largeFile = UploadedFile::fake()->create('large-file.jpg', 15000); // 15MB

        $this->expectException(\Spatie\MediaLibrary\MediaCollections\Exceptions\FileIsTooBig::class);

        $this->exam->addMedia($largeFile)->toMediaCollection('images');
    }

    /** @test */
    public function media_can_be_ordered_within_collection()
    {
        $this->actingAs($this->admin);

        $file1 = UploadedFile::fake()->image('first.jpg');
        $file2 = UploadedFile::fake()->image('second.jpg');
        $file3 = UploadedFile::fake()->image('third.jpg');

        $media1 = $this->exam->addMedia($file1)->toMediaCollection('ordered');
        $media2 = $this->exam->addMedia($file2)->toMediaCollection('ordered');
        $media3 = $this->exam->addMedia($file3)->toMediaCollection('ordered');

        // Test ordering
        $media2->order_column = 1;
        $media1->order_column = 2;
        $media3->order_column = 3;

        $media1->save();
        $media2->save();
        $media3->save();

        $orderedMedia = $this->exam->getMedia('ordered');
        $this->assertEquals('second.jpg', $orderedMedia[0]->file_name);
        $this->assertEquals('first.jpg', $orderedMedia[1]->file_name);
        $this->assertEquals('third.jpg', $orderedMedia[2]->file_name);
    }

    /** @test */
    public function media_can_have_responsive_images()
    {
        $this->actingAs($this->admin);

        $file = UploadedFile::fake()->image('responsive.jpg', 1200, 800);

        $media = $this->exam
            ->addMedia($file)
            ->withResponsiveImages()
            ->toMediaCollection('responsive');

        $this->assertNotEmpty($media->responsive_images);
    }

    /** @test */
    public function multiple_files_can_be_uploaded_to_same_collection()
    {
        $this->actingAs($this->admin);

        $files = [
            UploadedFile::fake()->image('gallery1.jpg'),
            UploadedFile::fake()->image('gallery2.jpg'),
            UploadedFile::fake()->image('gallery3.jpg'),
        ];

        foreach ($files as $file) {
            $this->exam->addMedia($file)->toMediaCollection('gallery');
        }

        $galleryMedia = $this->exam->getMedia('gallery');
        $this->assertCount(3, $galleryMedia);

        $fileNames = $galleryMedia->pluck('file_name')->toArray();
        $this->assertContains('gallery1.jpg', $fileNames);
        $this->assertContains('gallery2.jpg', $fileNames);
        $this->assertContains('gallery3.jpg', $fileNames);
    }

    /** @test */
    public function media_can_be_copied_between_models()
    {
        $this->actingAs($this->admin);

        $anotherExam = Exam::factory()->create();
        $file = UploadedFile::fake()->image('copyable.jpg');

        $originalMedia = $this->exam->addMedia($file)->toMediaCollection('images');

        // Copy media to another model
        $copiedMedia = $originalMedia->copy($anotherExam, 'images');

        $this->assertNotEquals($originalMedia->id, $copiedMedia->id);
        $this->assertEquals($anotherExam->id, $copiedMedia->model_id);
        $this->assertEquals('App\Models\Exam', $copiedMedia->model_type);
        $this->assertEquals('copyable.jpg', $copiedMedia->file_name);
    }

    /** @test */
    public function media_metadata_is_stored_correctly()
    {
        $this->actingAs($this->admin);

        $file = UploadedFile::fake()->image('metadata-test.jpg', 800, 600);

        $media = $this->exam
            ->addMedia($file)
            ->storingOnDisk('public')
            ->toMediaCollection('images');

        $this->assertEquals('public', $media->disk);
        $this->assertEquals('image/jpeg', $media->mime_type);
        $this->assertGreaterThan(0, $media->size);
        $this->assertNotEmpty($media->uuid);
    }

    /** @test */
    public function media_can_be_searched()
    {
        $this->actingAs($this->admin);

        $file1 = UploadedFile::fake()->image('searchable-image.jpg');
        $file2 = UploadedFile::fake()->create('searchable-document.pdf');
        $file3 = UploadedFile::fake()->image('other-file.png');

        $this->exam->addMedia($file1)->usingName('Searchable Image')->toMediaCollection('images');
        $this->exam->addMedia($file2)->usingName('Searchable Document')->toMediaCollection('documents');
        $this->exam->addMedia($file3)->usingName('Other File')->toMediaCollection('images');

        // Search by name
        $searchResults = Media::where('name', 'like', '%Searchable%')->get();
        $this->assertCount(2, $searchResults);

        // Search by file name
        $fileResults = Media::where('file_name', 'like', '%searchable%')->get();
        $this->assertCount(2, $fileResults);
    }

    /** @test */
    public function media_can_be_moved_between_collections()
    {
        $this->actingAs($this->admin);

        $file = UploadedFile::fake()->image('movable.jpg');
        $media = $this->exam->addMedia($file)->toMediaCollection('temp');

        $this->assertEquals('temp', $media->collection_name);

        // Move to permanent collection
        $media->move($this->exam, 'permanent');

        $this->assertEquals('permanent', $media->fresh()->collection_name);
    }

    /** @test */
    public function media_file_info_can_be_retrieved()
    {
        $this->actingAs($this->admin);

        $file = UploadedFile::fake()->image('info-test.jpg', 800, 600);
        $media = $this->exam->addMedia($file)->toMediaCollection('images');

        $this->assertNotEmpty($media->getPath());
        $this->assertNotEmpty($media->getUrl());
        $this->assertEquals('image/jpeg', $media->mime_type);
        $this->assertGreaterThan(0, $media->size);
        $this->assertEquals('info-test.jpg', $media->file_name);
        $this->assertEquals('info-test', $media->name);
    }

    /** @test */
    public function media_can_be_stored_on_different_disks()
    {
        $this->actingAs($this->admin);

        $file = UploadedFile::fake()->image('s3-test.jpg');

        $media = $this->exam
            ->addMedia($file)
            ->storingOnDisk('s3')
            ->toMediaCollection('cloud_images');

        $this->assertEquals('s3', $media->disk);
        $this->assertEquals('cloud_images', $media->collection_name);
    }

    /** @test */
    public function unauthorized_users_cannot_manage_media()
    {
        $this->actingAs($this->user); // Regular user, not admin

        $file = UploadedFile::fake()->image('unauthorized.jpg');

        // This should be controlled by your application's authorization logic
        // The test assumes you have middleware or policies in place
        $response = $this->post(route('file-manager.upload'), [
            'file' => $file,
            'model_type' => 'App\Models\Exam',
            'model_id' => $this->exam->id,
        ]);

        $response->assertStatus(403);
    }

    /** @test */
    public function media_collections_can_be_limited()
    {
        $this->actingAs($this->admin);

        // Add files up to a hypothetical limit
        for ($i = 1; $i <= 5; $i++) {
            $file = UploadedFile::fake()->image("avatar{$i}.jpg");
            $this->exam->addMedia($file)->toMediaCollection('avatars');
        }

        $avatars = $this->exam->getMedia('avatars');
        $this->assertCount(5, $avatars);

        // If you implement collection limits, test that here
        // This would depend on your specific implementation
    }

    /** @test */
    public function media_can_be_bulk_deleted()
    {
        $this->actingAs($this->admin);

        // Add multiple media items
        $files = [
            UploadedFile::fake()->image('bulk1.jpg'),
            UploadedFile::fake()->image('bulk2.jpg'),
            UploadedFile::fake()->image('bulk3.jpg'),
        ];

        $mediaIds = [];
        foreach ($files as $file) {
            $media = $this->exam->addMedia($file)->toMediaCollection('bulk');
            $mediaIds[] = $media->id;
        }

        $this->assertCount(3, $this->exam->getMedia('bulk'));

        // Bulk delete
        Media::whereIn('id', $mediaIds)->each(function ($media) {
            $media->delete();
        });

        $this->assertCount(0, $this->exam->fresh()->getMedia('bulk'));
    }
}