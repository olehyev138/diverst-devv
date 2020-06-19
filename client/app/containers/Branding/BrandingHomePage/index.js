import React, { memo, useEffect, useContext } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import reducer from 'containers/GlobalSettings/EnterpriseConfiguration/reducer';
import saga from 'containers/GlobalSettings/EnterpriseConfiguration/saga';
import {
  updateEnterpriseBegin,
} from 'containers/GlobalSettings/EnterpriseConfiguration/actions';

import BrandingHome from 'components/Branding/BrandingHome';

import messages from 'containers/Branding/messages';
import { injectIntl, intlShape } from 'react-intl';
import Conditional from 'components/Compositions/Conditional';
import { ROUTES } from 'containers/Shared/Routes/constants';
import { selectPermissions, selectEnterprise } from 'containers/Shared/App/selectors';
import permissionMessages from 'containers/Shared/Permissions/messages';

export function BrandingHomePage(props) {
  useInjectReducer({ key: 'configuration', reducer });
  useInjectSaga({ key: 'configuration', saga });
  const { intl } = props;

  return (
    <React.Fragment>
      <BrandingHome
        enterpriseAction={props.updateEnterpriseBegin}
        enterprise={props.enterprise}
        buttonText={intl.formatMessage(messages.update)}
      />
    </React.Fragment>
  );
}

BrandingHomePage.propTypes = {
  intl: intlShape,
  enterprise: PropTypes.object,
  updateEnterpriseBegin: PropTypes.func,
};

const mapStateToProps = createStructuredSelector({
  enterprise: selectEnterprise(),
  permissions: selectPermissions(),
});

const mapDispatchToProps = {
  updateEnterpriseBegin,
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
  BrandingHomePage,
  ['permissions.branding_manage'],
  (props, rs) => props.permissions.adminPath || ROUTES.user.home.path(),
  permissionMessages.branding.homePage
));
