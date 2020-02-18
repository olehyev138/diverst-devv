import React, { memo, useEffect, useContext } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import reducer from 'containers/GlobalSettings/EnterpriseConfiguration/reducer';
import saga from 'containers/GlobalSettings/EnterpriseConfiguration/saga';
import { selectEnterprise } from 'containers/GlobalSettings/EnterpriseConfiguration/selectors';
import {
  getEnterpriseBegin,
  updateEnterpriseBegin,
  configurationUnmount
} from 'containers/GlobalSettings/EnterpriseConfiguration/actions';

import RouteService from 'utils/routeHelpers';
import BrandingHome from 'components/Branding/BrandingHome';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Branding/messages';

export function BrandingHomePage(props) {
  useInjectReducer({ key: 'configuration', reducer });
  useInjectSaga({ key: 'configuration', saga });

  useEffect(() => {
    props.getEnterpriseBegin();

    return () => {
      props.configurationUnmount();
    };
  }, []);

  return (
    <React.Fragment>
      <BrandingHome
        enterpriseAction={props.updateEnterpriseBegin}
        enterprise={props.enterprise}
        buttonText={<DiverstFormattedMessage {...messages.update} />}
      />
    </React.Fragment>
  );
}

BrandingHomePage.propTypes = {
  enterprise: PropTypes.object,
  getEnterpriseBegin: PropTypes.func,
  updateEnterpriseBegin: PropTypes.func,
  configurationUnmount: PropTypes.func
};

const mapStateToProps = createStructuredSelector({
  enterprise: selectEnterprise()
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
  withConnect,
  memo,
)(BrandingHomePage);
