import React, {
  memo, useEffect, useContext, useState
} from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/Innovate/Campaign/CampaignQuestion/reducer';
import saga from 'containers/Innovate/Campaign/CampaignQuestion/saga';

import {
  getQuestionsBegin, deleteQuestionBegin,
  campaignQuestionsUnmount
} from 'containers/Innovate/Campaign/CampaignQuestion/actions';
import {
  selectPaginatedQuestions, selectQuestionTotal,
  selectIsFetchingQuestions
} from 'containers/Innovate/Campaign/CampaignQuestion/selectors';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import CampaignQuestionsList from 'components/Innovate/Campaign/CampaignQuestion/CampaignQuestionsList';
import { push } from 'connected-react-router';

export function CampaignQuestionListPage(props) {
  useInjectReducer({ key: 'questions', reducer });
  useInjectSaga({ key: 'questions', saga });

  const rs = new RouteService(useContext);
  const campaignId = rs.params('campaign_id');

  const [params, setParams] = useState({
    campaign_id: campaignId, count: 10, page: 0,
    orderBy: 'questions.id', order: 'asc'
  });

  const links = {
    campaignQuestionNew: ROUTES.admin.innovate.campaigns.questions.new.path(campaignId),
    campaignQuestionEdit: id => ROUTES.admin.innovate.campaigns.questions.new.path(campaignId, id)
  };

  const handlePagination = (payload) => {
    const newParams = { ...params, count: payload.count, page: payload.page };

    props.getQuestionsBegin(newParams);
    setParams(newParams);
  };

  const handleOrdering = (payload) => {
    const newParams = { ...params, orderBy: payload.orderBy, order: payload.orderDir };

    props.getQuestionsBegin(newParams);
    setParams(newParams);
  };

  useEffect(() => {
    props.getQuestionsBegin(params);

    return () => {
      props.campaignQuestionsUnmount();
    };
  }, []);

  return (
    <React.Fragment>
      <CampaignQuestionsList
        questionList={props.questionList}
        questionTotal={props.questionTotal}
        isFetchingQuestions={props.isFetchingQuestions}
        campaignId={campaignId}
        handleVisitQuestionEdit={props.handleVisitQuestionEdit}
        handleVisitQuestionShow={props.handleVisitQuestionShow}
        deleteQuestionBegin={props.deleteQuestionBegin}
        links={links}
        setParams={params}
        params={params}
        handlePagination={handlePagination}
        handleOrdering={handleOrdering}
      />
    </React.Fragment>
  );
}

CampaignQuestionListPage.propTypes = {
  getQuestionsBegin: PropTypes.func,
  deleteQuestionBegin: PropTypes.func,
  campaignQuestionsUnmount: PropTypes.func,
  questionList: PropTypes.array,
  questionTotal: PropTypes.number,
  isFetchingQuestions: PropTypes.bool,
  handleVisitQuestionEdit: PropTypes.func,
  handleVisitQuestionShow: PropTypes.func,
};

const mapStateToProps = createStructuredSelector({
  questionList: selectPaginatedQuestions(),
  questionTotal: selectQuestionTotal(),
  isFetchingQuestions: selectIsFetchingQuestions()
});

const mapDispatchToProps = dispatch => ({
  getQuestionsBegin: payload => dispatch(getQuestionsBegin(payload)),
  deleteQuestionBegin: payload => dispatch(deleteQuestionBegin(payload)),
  campaignQuestionsUnmount: () => dispatch(campaignQuestionsUnmount()),
  handleVisitQuestionEdit: (campaignId, id) => dispatch(push(ROUTES.admin.innovate.campaigns.questions.edit.path(campaignId, id))),
  handleVisitQuestionShow: (campaignId, id) => dispatch(push(ROUTES.admin.innovate.campaigns.questions.show.path(campaignId, id))),
});

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(CampaignQuestionListPage);
