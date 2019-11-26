import { createSelector } from 'reselect/lib';
import { initialState } from 'containers/Innovate/Campaign/CampaignQuestion/reducer';
import { selectCampaignsDomain } from '/../selectors';
import { selectQuestionsDomain } from '/./selectors';


const selectAnswersDomain = state => state.answers || initialState;

const selectAnswer = () => createSelector(
  selectAnswersDomain,
  answersState => answersState.currentAnswer
);

const selectPaginatedAnswers = () => createSelector(
  selectAnswersDomain,
  answersState => answersState.answerList
);

/* Select user list & format it for a select
 *  looks like: [ { value: <>, label: <> } ... ]
 */
const selectPaginatedSelectAnswers = () => createSelector(
  selectAnswersDomain,
  answersState => (
    Object
      .values(answersState.answerList)
      .map(answer => ({
        value: answer.id,
        label: `${answer.answer}`
      }))
  )
);

const selectAnswerTotal = () => createSelector(
  selectAnswersDomain,
  answersState => answersState.answerTotal
);

const selectIsFetchingAnswers = () => createSelector(
  selectAnswersDomain,
  answersState => answersState.isFetchingAnswers
);

const selectIsCommitting = () => createSelector(
  selectAnswersDomain,
  answersState => answersState.isCommitting
);

export {
  selectAnswersDomain, selectPaginatedAnswers, selectPaginatedSelectAnswers,
  selectAnswerTotal, selectIsFetchingAnswers, selectIsCommitting, selectAnswer
}
