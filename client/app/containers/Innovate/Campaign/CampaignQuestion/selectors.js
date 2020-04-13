import { createSelector } from 'reselect/lib';
import { initialState } from 'containers/Innovate/Campaign/CampaignQuestion/reducer';
import { selectCampaignsDomain } from '../selectors';


const selectQuestionsDomain = state => state.questions || initialState;

const selectQuestion = () => createSelector(
  selectQuestionsDomain,
  questionsState => questionsState.currentQuestion
);

const selectPaginatedQuestions = () => createSelector(
  selectQuestionsDomain,
  questionsState => questionsState.questionList
);

/* Select user list & format it for a select
 *  looks like: [ { value: <>, label: <> } ... ]
 */
const selectPaginatedSelectQuestions = () => createSelector(
  selectQuestionsDomain,
  questionsState => (
    Object
      .values(questionsState.questionList)
      .map(question => ({
        value: question.id,
        label: `${question.question}`
      }))
  )
);

const selectQuestionTotal = () => createSelector(
  selectQuestionsDomain,
  questionsState => questionsState.questionTotal
);

const selectIsFetchingQuestions = () => createSelector(
  selectQuestionsDomain,
  questionsState => questionsState.isFetchingQuestions
);

const selectIsFormLoading = () => createSelector(
  selectQuestionsDomain,
  questionsState => questionsState.isFormLoading
);

const selectIsCommitting = () => createSelector(
  selectQuestionsDomain,
  questionsState => questionsState.isCommitting
);

export {
  selectQuestionsDomain, selectPaginatedQuestions, selectPaginatedSelectQuestions,
  selectQuestionTotal, selectIsFetchingQuestions, selectIsFormLoading, selectIsCommitting, selectQuestion
};
