import React, { memo, useEffect, useContext } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import reducer from '../../../Shared/Sponsors/reducer';
import saga from 'containers/Branding/Sponsor/enterprisesponsorsSaga';
import {
  createSponsorBegin,
  sponsorsUnmount
} from '../../../Shared/Sponsors/actions';

import RouteService from 'utils/routeHelpers';
import SponsorForm from 'components/Branding/Sponsor/SponsorForm';
import { ROUTES } from 'containers/Shared/Routes/constants';

import messages from 'containers/Branding/messages';
import { injectIntl, intlShape } from 'react-intl';
import Conditional from 'components/Compositions/Conditional';
import { selectPermissions } from 'containers/Shared/App/selectors';
import permissionMessages from 'containers/Shared/Permissions/messages';

export function SponsorCreatePage(props) {
  useInjectReducer({ key: 'sponsors', reducer });
  useInjectSaga({ key: 'sponsors', saga });
  const { intl } = props;
  const links = {
    sponsorIndex: ROUTES.admin.system.branding.sponsors.index.path(),
  };

  useEffect(() => () => props.sponsorsUnmount(), []);

  return (
    <React.Fragment>
      <SponsorForm
        sponsorAction={props.createSponsorBegin}
        links={links}
        buttonText={intl.formatMessage(messages.create)}
        sponsorableId={null}
      />
    </React.Fragment>
  );
}

SponsorCreatePage.propTypes = {
  intl: intlShape.isRequired,
  createSponsorBegin: PropTypes.func,
  sponsorsUnmount: PropTypes.func
};

const mapStateToProps = createStructuredSelector({
  permissions: selectPermissions(),
});

const mapDispatchToProps = {
  createSponsorBegin,
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
  SponsorCreatePage,
  ['permissions.branding_manage'],
  (props, rs) => props.permissions.adminPath || ROUTES.user.home.path(),
  permissionMessages.branding.sponsor.createPage
));
