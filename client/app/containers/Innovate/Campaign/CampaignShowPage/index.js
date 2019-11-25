import React, {
  memo, useContext, useEffect, useState
} from 'react';

import CampaignQuestionListPage from 'containers/Innovate/Campaign/CampaignQuestion/CampaignQuestionListPage';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/Innovate/Campaign/reducer';
import saga from 'containers/Innovate/Campaign/saga';

import { getCampaignBegin, campaignsUnmount } from 'containers/Innovate/Campaign/actions';
import { selectCampaignTotal, selectCampaign, selectIsCommitting } from 'containers/Innovate/Campaign/selectors';

import CampaignShow from 'components/Innovate/Campaign/CampaignShow';

export function CampaignShowPage(props) {
  useInjectReducer({ key: 'campaigns', reducer });
  useInjectSaga({ key: 'campaigns', saga });

  const rs = new RouteService(useContext);
  const campaignId = rs.params('campaign_id')[0];

  const [params, setParams] = useState({
    count: 10, page: 0, orderBy: '', order: 'asc'
  });

  const links = {
    CampaignsIndex: ROUTES.admin.innovate.campaigns.index.path(),
  };

  useEffect(() => {
    const campaignId = rs.params('campaign_id');
    props.getCampaignBegin({ id: rs.params('campaign_id') });

    return () => props.campaignsUnmount();
  }, []);
  return (
    <React.Fragment>
      <CampaignQuestionListPage />
    </React.Fragment>
  );
}

CampaignShowPage.propTypes = {
  getCampaignBegin: PropTypes.func,
  campaignsUnmount: PropTypes.func,
  isFormLoading: PropTypes.func,
  campaign: PropTypes.object,
  users: PropTypes.array,
};

const mapStateToProps = createStructuredSelector({
  campaign: selectCampaign(),
});

const mapDispatchToProps = {
  getCampaignBegin,
  campaignsUnmount,
};
const withConnect = connect(
  mapStateToProps,

  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(CampaignShowPage);
