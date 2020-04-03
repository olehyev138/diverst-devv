import React, { memo, useEffect, useContext } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import { selectSponsor } from '../selectors';
import reducer from '../reducer';
import saga from '../saga';
import {
  getSponsorBegin,
  updateSponsorBegin,
  sponsorsUnmount
} from '../actions';

import RouteService from 'utils/routeHelpers';
import SponsorForm from 'components/Branding/Sponsor/SponsorForm';
import { ROUTES } from 'containers/Shared/Routes/constants';

import { injectIntl, intlShape } from 'react-intl';
import messages from 'containers/Branding/messages';
import Conditional from 'components/Compositions/Conditional';
import { selectPermissions } from 'containers/Shared/App/selectors';

export function SponsorEditPage(props) {
  useInjectReducer({ key: 'sponsors', reducer });
  useInjectSaga({ key: 'sponsors', saga });

  const rs = new RouteService(useContext);
  const links = {
    sponsorIndex: ROUTES.admin.system.branding.sponsors.index.path(),
  };
  const { intl } = props;
  useEffect(() => {
    props.getSponsorBegin({ id: rs.params('sponsor_id') });

    return () => {
      props.sponsorsUnmount();
    };
  }, []);


  return (
    <React.Fragment>
      <SponsorForm
        sponsor={props.sponsor}
        sponsorAction={props.updateSponsorBegin}
        links={links}
        buttonText={intl.formatMessage(messages.create)}
      />
    </React.Fragment>
  );
}

SponsorEditPage.propTypes = {
  intl: intlShape,
  sponsor: PropTypes.object,
  getSponsorBegin: PropTypes.func,
  updateSponsorBegin: PropTypes.func,
  sponsorsUnmount: PropTypes.func
};

const mapStateToProps = createStructuredSelector({
  sponsor: selectSponsor(),
  permissions: selectPermissions(),
});

const mapDispatchToProps = {
  getSponsorBegin,
  updateSponsorBegin,
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
)(Conditional(
  SponsorEditPage,
  ['permissions.branding_manage'],
  (props, rs) => props.permissions.adminPath || ROUTES.user.home.path(),
  'You don\'t have permission manage branding'
));
