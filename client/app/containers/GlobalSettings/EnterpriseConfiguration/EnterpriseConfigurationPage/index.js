import React, { memo, useEffect, useContext } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import reducer from '../reducer';
import saga from '../saga';
import { selectEnterprise } from '../selectors';
import {
  getEnterpriseBegin,
  updateEnterpriseBegin,
  configurationUnmount
} from '../actions';

import RouteService from 'utils/routeHelpers';
import EnterpriseConfiguration from 'components/GlobalSettings/EnterpriseConfiguration';

export function EnterpriseConfigurationPage(props) {
  useInjectReducer({ key: 'configuration', reducer });
  useInjectSaga({ key: 'configuration', saga });

  useEffect(() => {
    // todo: get enterprise id
    props.getEnterpriseBegin({});

    return () => {
      props.configurationUnmount();
    };
  }, []);

  return (
    <React.Fragment>
      <EnterpriseConfiguration
        enterpriseAction={props.updateEnterpriseBegin}
        enterprise={props.enterprise}
        buttonText='Update'
      />
    </React.Fragment>
  );
}

EnterpriseConfigurationPage.propTypes = {
  enterprise: PropTypes.object,
  getEnterpriseBegin: PropTypes.func,
  updateEnterpriseBegin: PropTypes.func,
  configurationUnmount: PropTypes.func
};

const mapStateToProps = createStructuredSelector({
});

const mapDispatchToProps = {
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(EnterpriseConfigurationPage);
