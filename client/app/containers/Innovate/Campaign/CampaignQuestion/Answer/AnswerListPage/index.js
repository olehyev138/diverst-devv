import React, {
  memo, useEffect, useContext, useState
} from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/Innovate/Campaign/CampaignQuestion/Answer/reducer';
import saga from 'containers/Innovate/Campaign/CampaignQuestion/Answer/saga';

import {
  getAnswersBegin, deleteAnswerBegin,
  questionAnswersUnmount
} from 'containers/Innovate/Campaign/CampaignQuestion/Answer/actions';
import {
  selectPaginatedAnswers, selectAnswerTotal,
  selectIsFetchingAnswers
} from 'containers/Innovate/Campaign/CampaignQuestion/Answer/selectors';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import AnswerList from 'components/Innovate/Campaign/CampaignQuestion/Answer/AnswerList';
import { push } from 'connected-react-router';


export function AnswerListPage(props) {
  useInjectReducer({ key: 'answers', reducer });
  useInjectSaga({ key: 'answers', saga });

  const rs = new RouteService(useContext);
  const questionId = rs.params('question_id');
  const campaignId = rs.params('campaign_id');

  const [params, setParams] = useState({
    question_id: questionId, count: 5, page: 0,
    orderBy: 'answers.id', order: 'asc'
  });

  // const links = {
  //   campaignAnswerNew: ROUTES.admin.innovate.campaigns.answers.new.path(campaignId),
  //   campaignAnswerEdit: id => ROUTES.admin.innovate.campaigns.answers.new.path(campaignId, id)
  // };

  const handlePagination = (payload) => {
    const newParams = { ...params, count: payload.count, page: payload.page };

    props.getAnswersBegin(newParams);
    setParams(newParams);
  };

  const handleOrdering = (payload) => {
    const newParams = { ...params, orderBy: payload.orderBy, order: payload.orderDir };

    props.getAnswersBegin(newParams);
    setParams(newParams);
  };

  useEffect(() => {
    props.getAnswersBegin(params);
    return () => {
      props.questionAnswersUnmount();
    };
  }, []);

  return (
    <React.Fragment>
      <AnswerList
        answerList={props.answerList}
        answerTotal={props.answerTotal}
        isFetchingAnswers={props.isFetchingAnswers}
        questionId={questionId}
        handleVisitAnswerEdit={props.handleVisitAnswerEdit}
        handleVisitAnswerShow={props.handleVisitAnswerShow}
        deleteAnswerBegin={props.deleteAnswerBegin}
        // links={links}
        setParams={params}
        params={params}
        handlePagination={handlePagination}
        handleOrdering={handleOrdering}
      />
    </React.Fragment>
  );
}

AnswerListPage.propTypes = {
  getAnswersBegin: PropTypes.func,
  deleteAnswerBegin: PropTypes.func,
  questionAnswersUnmount: PropTypes.func,
  answerList: PropTypes.array,
  answerTotal: PropTypes.number,
  isFetchingAnswers: PropTypes.bool,
  handleVisitAnswerEdit: PropTypes.func,
  handleVisitAnswerShow: PropTypes.func,
};

const mapStateToProps = createStructuredSelector({
  answerList: selectPaginatedAnswers(),
  answerTotal: selectAnswerTotal(),
  isFetchingAnswers: selectIsFetchingAnswers()
});

const mapDispatchToProps = dispatch => ({
  getAnswersBegin: payload => dispatch(getAnswersBegin(payload)),
  deleteAnswerBegin: payload => dispatch(deleteAnswerBegin(payload)),
  questionAnswersUnmount: () => dispatch(questionAnswersUnmount()),
  handleVisitAnswerEdit: (campaignId, questionId, id) => dispatch(push(ROUTES.admin.innovate.campaigns.questions.answers.edit.path(campaignId, questionId, id))),
  handleVisitAnswerShow: (campaignId, questionId, id) => dispatch(push(ROUTES.admin.innovate.campaigns.questions.answers.show.path(campaignId, questionId, id))),
});

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(AnswerListPage);
