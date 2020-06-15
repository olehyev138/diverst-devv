import React, { memo, useEffect, useContext } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import reducer from 'containers/GlobalSettings/EnterpriseConfiguration/reducer';
import saga from 'containers/GlobalSettings/EnterpriseConfiguration/saga';
import { selectEnterpriseTheme, selectEnterpriseIsCommitting, selectEnterpriseIsLoading } from 'containers/GlobalSettings/EnterpriseConfiguration/selectors';
import {
  getEnterpriseBegin,
  updateEnterpriseBegin,
  configurationUnmount
} from 'containers/GlobalSettings/EnterpriseConfiguration/actions';

import RouteService from 'utils/routeHelpers';
import BrandingTheme from 'components/Branding/BrandingTheme';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Branding/messages';
import { injectIntl, intlShape } from 'react-intl';
import Conditional from 'components/Compositions/Conditional';
import { ROUTES } from 'containers/Shared/Routes/constants';
import { selectPermissions } from 'containers/Shared/App/selectors';
import permissionMessages from 'containers/Shared/Permissions/messages';
export function BrandingThemePage(props) {
  useInjectReducer({ key: 'configuration', reducer });
  useInjectSaga({ key: 'configuration', saga });
  const { intl } = props;
  useEffect(() => {
    props.getEnterpriseBegin();

    return () => {
      props.configurationUnmount();
    };
  }, []);

  return (
    <React.Fragment>
      <BrandingTheme
        enterpriseAction={props.updateEnterpriseBegin}
        theme={props.theme}
        isLoading={props.isLoading}
        isCommitting={props.isCommitting}
        buttonText={intl.formatMessage(messages.update)}
      />
    </React.Fragment>
  );
}

BrandingThemePage.propTypes = {
  intl: intlShape.isRequired,
  theme: PropTypes.object,
  getEnterpriseBegin: PropTypes.func,
  updateEnterpriseBegin: PropTypes.func,
  configurationUnmount: PropTypes.func,
  isLoading: PropTypes.bool,
  isCommitting: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  theme: selectEnterpriseTheme(),
  isLoading: selectEnterpriseIsLoading(),
  isCommitting: selectEnterpriseIsCommitting(),
  permissions: selectPermissions(),
});

const mapDispatchToProps = {
  getEnterpriseBegin,
  updateEnterpriseBegin,
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
  BrandingThemePage,
  ['permissions.branding_manage'],
  (props, rs) => props.permissions.adminPath || ROUTES.user.home.path(),
  permissionMessages.branding.themePage
));
