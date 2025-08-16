# User Composition Migration Guide

## Overview

This guide documents the migration of user-facing Vue.js pages (ExamScreen, QuizScreen, PracticeScreen) to Vue 3 Composition API patterns, with a focus on creating reusable composables for common functionality.

## Migration Summary

### Key Changes

1. **Composable Architecture**: Extracted common functionality into reusable composables
2. **Timer Management**: Centralized timer logic with consistent API
3. **Session Management**: Unified session state management across all screens
4. **Question Navigation**: Standardized question status tracking and navigation
5. **API Integration**: Improved answer submission and state synchronization
6. **Bug Fixes**: Resolved various edge cases and inconsistencies

## Composables Overview

### 1. `useTimer.js`

**Purpose**: Provides timer functionality with countdown/countup modes, auto-start, and lifecycle management.

**Key Features**:
- Countdown and count-up modes
- Auto-start with duplicate prevention
- Time formatting utilities
- Warning time detection
- Persistent state management

**API**:
```javascript
const timer = useTimer({
    duration: 3600, // seconds
    countDown: true,
    autoStart: true,
    onExpire: () => { /* handle expiry */ }
})

// Access timer state
timer.isActive           // computed boolean
timer.currentTime        // computed seconds
timer.formattedCurrentTime // computed string "MM:SS" or "HH:MM:SS"
timer.progress          // computed percentage

// Control methods
timer.startTimer()
timer.pauseTimer()
timer.stopTimer()
timer.resetTimer()
```

**Fixes Applied**:
- Added `readonly` import to resolve ReferenceError
- Added guard clause in `startTimer()` to prevent duplicate intervals
- Removed double auto-start issue

### 2. `useSessionManager.js`

**Purpose**: Manages session state, answers, and question statuses across all user screens.

**Key Features**:
- Session state management
- Answer submission with flexible endpoints
- Auto-save functionality
- Progress tracking
- Question status synchronization

**API**:
```javascript
const sessionManager = useSessionManager({
    id: sessionId,
    current_question: 0,
    questions: [],
    // ... other initial state
})

// Computed properties
sessionManager.answeredCount     // includes answered_mark_for_review
sessionManager.notAnsweredCount  // excludes not_visited
sessionManager.notVisitedCount   // separate from not_answered
sessionManager.progressPercentage

// Methods
sessionManager.updateAnswer(questionId, answer, options)
sessionManager.submitAnswer(questionId, answer, options)
sessionManager.updateQuestionStatus(questionIndex, status)
sessionManager.nextQuestion()
sessionManager.jumpToQuestion(questionIndex)
```

**Fixes Applied**:
- Fixed `answeredCount` to include `answered_mark_for_review` status
- Added `updateQuestionStatus` method for proper status management
- Separated `notVisitedCount` from `notAnsweredCount`
- Enhanced `submitAnswer` with flexible endpoint and callback options

### 3. `useQuestionNavigation.js`

**Purpose**: Handles question navigation, filtering, and status management for large question sets.

**Key Features**:
- Question status tracking
- Navigation with sections support
- Filtering and search
- Statistics computation
- Bulk operations

**API**:
```javascript
const navigation = useQuestionNavigation(questions, sections)

// Computed statistics
navigation.answeredQuestions
navigation.notAnsweredQuestions
navigation.markedForReviewQuestions
navigation.answeredMarkForReviewQuestions  // NEW
navigation.notVisitedQuestions             // NEW

// Methods
navigation.updateQuestionStatus(index, status)
navigation.toggleMarkForReview(index)
navigation.jumpToQuestion(index, callback)
navigation.initializeStatuses(statuses)
```

**Fixes Applied**:
- Added `answeredMarkForReviewQuestions` computed property
- Added `notVisitedQuestions` computed property
- Fixed `toggleMarkForReview` logic to use current status instead of non-existent keys
- Updated `notAnsweredQuestions` to exclude `not_visited` status

## Screen-Specific Changes

### ExamScreen.vue

**Major Changes**:
1. **Section Timer Initialization**: Section timers are now properly initialized when fetching questions
2. **Tooltip Standardization**: Uses `defineOptions` for cleaner directive registration
3. **Session Integration**: Proper integration with sessionManager for status updates

**Key Code Changes**:
```javascript
// Section timer initialization
if (!sectionTimers.value[currentSectionIndex] && data.remainingTime) {
    sectionTimers.value[currentSectionIndex] = useTimer({
        duration: data.remainingTime,
        countDown: true,
        autoStart: true
    })
}

// Directive registration
defineOptions({
    directives: {
        tooltip: Tooltip
    }
})
```

### QuizScreen.vue

**Major Changes**:
1. **Timer API**: Updated to use `formattedCurrentTime` instead of accessing individual time components
2. **Tooltip Standardization**: Consistent directive registration pattern
3. **Session Integration**: Proper answer submission and status management

**Key Code Changes**:
```javascript
// Timer display - OLD
{{ quizTimer.hours !== '00' ? quizTimer.hours + ':' : '' }}{{ quizTimer.minutes }}:{{ quizTimer.seconds }}

// Timer display - NEW  
{{ quizTimer.formattedCurrentTime }}
```

### PracticeScreen.vue

**Major Changes**:
1. **Property Binding**: Fixed `totalPointsEarned` binding to use session object
2. **Inertia Migration**: Replaced `inertia-link` with `Link` component
3. **Import Updates**: Added `Link` import from `@inertiajs/vue3`

**Key Code Changes**:
```javascript
// OLD
import { Head } from '@inertiajs/vue3'
<inertia-link>...</inertia-link>
:points="sessionManager.totalPointsEarned"

// NEW
import { Head, Link } from '@inertiajs/vue3'
<Link>...</Link>
:points="sessionManager.session.total_points_earned"
```

## Question Status Semantics

### Status Values
- `not_visited`: Question has never been accessed
- `not_answered`: Question was visited but no answer provided
- `answered`: Question has a valid answer
- `mark_for_review`: Question marked for review (may or may not have answer)
- `answered_mark_for_review`: Question has answer AND is marked for review

### Computed Properties
- `answeredCount`: Includes both `answered` and `answered_mark_for_review`
- `notAnsweredCount`: Only questions with `not_answered` status
- `notVisitedCount`: Only questions with `not_visited` status
- `markedForReviewCount`: Both `mark_for_review` and `answered_mark_for_review`

## Breaking Changes

### Timer API
- **BREAKING**: `hours`, `minutes`, `seconds` properties no longer available
- **MIGRATION**: Use `formattedCurrentTime` computed property instead
- **IMPACT**: QuizScreen template updated to use new API

### Session Manager
- **BREAKING**: `totalPointsEarned` property moved to `session.total_points_earned`
- **MIGRATION**: Update property bindings to use session object
- **IMPACT**: PracticeScreen rewards badge binding updated

### Question Navigation  
- **BREAKING**: `toggleMarkForReview` logic changed to use current status
- **MIGRATION**: No template changes needed, logic automatically fixed
- **IMPACT**: Proper status toggling behavior

## Testing

### Automated Tests
The migration includes comprehensive test coverage in `UserCompositionMigrationTest.php`:

- ✅ Composable imports and structure
- ✅ Timer fixes (readonly import, guard clauses)
- ✅ Question navigation computed properties
- ✅ Session manager improvements
- ✅ Screen-specific API changes
- ✅ Tooltip directive standardization
- ✅ Backward compatibility

### Manual Testing Checklist

#### Timer Functionality
- [ ] Timer displays correctly on all screens
- [ ] Auto-start works without duplicate intervals
- [ ] Countdown/countup modes work as expected
- [ ] Timer expiry triggers appropriate actions

#### Session Management
- [ ] Answer submission works across all screens
- [ ] Question statuses update correctly
- [ ] Progress counts reflect actual answered questions
- [ ] Auto-save functionality maintains session state

#### Question Navigation
- [ ] Mark for review toggles work correctly
- [ ] Statistics display accurate counts
- [ ] Not visited vs not answered semantics are correct
- [ ] Question jumping preserves state

#### Screen Integration
- [ ] ExamScreen section timers initialize properly
- [ ] QuizScreen timer displays formatted time
- [ ] PracticeScreen rewards show correct points
- [ ] All tooltip directives work consistently

## Migration Best Practices

### 1. Composable Design
- **Single Responsibility**: Each composable handles one concern
- **Reactive State**: Use `ref` and `reactive` for state management
- **Computed Properties**: Derive values reactively
- **Lifecycle Integration**: Proper cleanup in `onUnmounted`

### 2. State Management
- **Centralized State**: Session data lives in one place
- **Consistent Updates**: Use composable methods for state changes
- **Status Synchronization**: Keep UI and backend in sync

### 3. Error Handling
- **Graceful Degradation**: Handle missing data scenarios
- **User Feedback**: Show loading states and error messages
- **Recovery Mechanisms**: Allow users to retry failed operations

### 4. Performance
- **Computed Caching**: Use computed properties for expensive calculations
- **Selective Updates**: Only re-render when necessary
- **Timer Cleanup**: Prevent memory leaks with proper cleanup

## Future Considerations

### Potential Improvements
1. **WebSocket Integration**: Real-time session synchronization
2. **Offline Support**: Local storage for temporary disconnections
3. **Progressive Enhancement**: Better loading states and skeleton screens
4. **Accessibility**: Enhanced keyboard navigation and screen reader support

### Monitoring Points
1. **Performance**: Monitor timer performance with large question sets
2. **Memory Usage**: Watch for potential memory leaks in long sessions
3. **User Experience**: Track submission failures and retry patterns
4. **Browser Compatibility**: Ensure consistent behavior across browsers

## Support and Documentation

### Resources
- Vue 3 Composition API: [https://vuejs.org/api/composition-api-setup.html](https://vuejs.org/api/composition-api-setup.html)
- Inertia.js Vue 3: [https://inertiajs.com/vue3](https://inertiajs.com/vue3)
- PrimeVue Components: [https://primevue.org/](https://primevue.org/)

### Getting Help
- Check test suite for usage examples
- Refer to composable source code for detailed API documentation
- Review screen implementations for integration patterns

---

This migration provides a solid foundation for maintainable, scalable user interfaces while preserving existing functionality and improving user experience.
