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
import {
  getEnterpriseBegin,
  updateEnterpriseBegin,
  configurationUnmount
} from 'containers/GlobalSettings/EnterpriseConfiguration/actions';

import RouteService from 'utils/routeHelpers';
import SSOSettings from 'components/GlobalSettings/SSOSettings';
import { injectIntl, intlShape } from 'react-intl';
import messages from 'containers/GlobalSettings/EnterpriseConfiguration/messages';
export function SSOSettingsPage(props) {
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
      <SSOSettings
        enterpriseAction={props.updateEnterpriseBegin}
        enterprise={props.enterprise}
        buttonText={intl.formatMessage(messages.update)}
      />
    </React.Fragment>
  );
}

SSOSettingsPage.propTypes = {
  intl: intlShape,
  enterprise: PropTypes.object,
  getEnterpriseBegin: PropTypes.func,
  updateEnterpriseBegin: PropTypes.func,
  configurationUnmount: PropTypes.func
};

const mapStateToProps = createStructuredSelector({
  enterprise: selectFormEnterprise()
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
)(SSOSettingsPage);
