import React, { memo, useEffect, useContext } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import reducer from 'containers/GlobalSettings/EnterpriseConfiguration/reducer';
import saga from 'containers/GlobalSettings/EnterpriseConfiguration/saga';
import { selectFormEnterprise } from 'containers/GlobalSettings/EnterpriseConfiguration/selectors';
import { selectIsCommitting } from 'containers/GlobalSettings/SSOSettingsPage/selectors';
import {
  getEnterpriseBegin,
  configurationUnmount
} from 'containers/GlobalSettings/EnterpriseConfiguration/actions';
import {
  updateSsoSettingsBegin
} from 'containers/GlobalSettings/SSOSettingsPage/actions';

import SSOSettings from 'components/GlobalSettings/SSOSettings';
import { injectIntl, intlShape } from 'react-intl';
import messages from 'containers/GlobalSettings/EnterpriseConfiguration/messages';
import Conditional from 'components/Compositions/Conditional';
import { ROUTES } from 'containers/Shared/Routes/constants';
import { selectPermissions } from 'containers/Shared/App/selectors';
import permissionMessages from 'containers/Shared/Permissions/messages';
import SSOSettingsSaga from './saga';
import SSOSettingsReducer from './reducer';

export function SSOSettingsPage(props) {
  useInjectReducer({ key: 'configuration', reducer });
  useInjectSaga({ key: 'configuration', saga });
  useInjectReducer({ key: 'SSOSettings', reducer: SSOSettingsReducer });
  useInjectSaga({ key: 'SSOSettings', saga: SSOSettingsSaga });
  const { intl } = props;
  useEffect(() => {
    props.getEnterpriseBegin();
    return () => {
      props.configurationUnmount();
    };
  }, []);

  return (
    <React.Fragment>
      <SSOSettings
        enterpriseAction={props.updateSsoSettingsBegin}
        enterprise={props.enterprise}
        buttonText={intl.formatMessage(messages.update)}
      />
    </React.Fragment>
  );
}

SSOSettingsPage.propTypes = {
  intl: intlShape.isRequired,
  isCommitting: PropTypes.bool,
  enterprise: PropTypes.object,
  getEnterpriseBegin: PropTypes.func,
  updateSsoSettingsBegin: PropTypes.func,
  configurationUnmount: PropTypes.func
};

const mapStateToProps = createStructuredSelector({
  enterprise: selectFormEnterprise(),
  permissions: selectPermissions(),
  isCommitting: selectIsCommitting(),
});

const mapDispatchToProps = {
  getEnterpriseBegin,
  updateSsoSettingsBegin,
  configurationUnmount
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
  SSOSettingsPage,
  ['permissions.sso_authentication'],
  (props, rs) => props.permissions.adminPath || ROUTES.user.home.path(),
  permissionMessages.globalSettings.SSOSettingsPage
));
