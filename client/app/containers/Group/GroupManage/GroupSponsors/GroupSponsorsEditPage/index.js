import React, { memo, useEffect, useContext } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import { selectSponsor } from 'containers/Branding/Sponsor/selectors';
import reducer from 'containers/Branding/Sponsor/reducer';
import saga from 'containers/Branding/Sponsor/saga';
import {
  getSponsorBegin,
  updateGroupSponsorBegin,
  sponsorsUnmount
} from 'containers/Branding/Sponsor/actions';

import RouteService from 'utils/routeHelpers';
import SponsorForm from 'components/Branding/Sponsor/SponsorForm';
import { ROUTES } from 'containers/Shared/Routes/constants';

import { injectIntl, intlShape } from 'react-intl';
import messages from 'containers/Branding/messages';

export function GroupSponsorCreatePage(props) {
  useInjectReducer({ key: 'sponsors', reducer });
  useInjectSaga({ key: 'sponsors', saga });

  const rs = new RouteService(useContext);
  const links = {
    sponsorIndex: ROUTES.group.manage.sponsors.index.path(rs.params('group_sponsor_id')),
  };
  const { intl } = props;

  useEffect(() => {
    props.getSponsorBegin({ id: rs.params('group_sponsor_id') });

    return () => {
      props.sponsorsUnmount();
    };
  }, []);


  return (
    <React.Fragment>
      <SponsorForm
        sponsor={props.sponsor}
        sponsorAction={props.updateGroupSponsorBegin}
        links={links}
        buttonText={intl.formatMessage(messages.create)}
        sponsorableId={rs.params('group_sponsor_id')}
      />
    </React.Fragment>
  );
}

GroupSponsorCreatePage.propTypes = {
  intl: intlShape,
  sponsor: PropTypes.object,
  getSponsorBegin: PropTypes.func,
  updateGroupSponsorBegin: PropTypes.func,
  sponsorsUnmount: PropTypes.func
};

const mapStateToProps = createStructuredSelector({
  sponsor: selectSponsor()
});

const mapDispatchToProps = {
  getSponsorBegin,
  updateGroupSponsorBegin,
  sponsorsUnmount
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  injectIntl,
  withConnect,
  memo,
)(GroupSponsorCreatePage);
