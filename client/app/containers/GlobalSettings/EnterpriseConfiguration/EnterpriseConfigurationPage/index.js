import React, { memo, useEffect, useContext } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
// import saga from 'containers/Group/saga';
// import reducer from 'containers/Group/reducer';

import RouteService from 'utils/routeHelpers';

// import { selectFormGroup, selectPaginatedSelectGroups } from 'containers/Group/selectors';
// import {
// } from 'containers/Group/actions';

import EnterpriseConfiguration from 'components/GlobalSettings/EnterpriseConfiguration';

export function EnterpriseConfigurationPage(props) {
  // useInjectReducer({ key: 'groups', reducer });
  // useInjectSaga({ key: 'groups', saga });

  // const rs = new RouteService(useContext);

  useEffect(() => {
    // props.getGroupBegin({ id: rs.params('group_id') });

    return () => {
      // props.groupFormUnmount();
    };
  }, []);

  return (
    <React.Fragment>
      <EnterpriseConfiguration
        groupAction={props.updateEnterpriseBegin}
        enterprise={props.enterprise}
        buttonText='Update'
      />
    </React.Fragment>
  );
}

EnterpriseConfigurationPage.propTypes = {
  enterprise: PropTypes.object,
  updateEnterpriseBegin: PropTypes.func,
  enterpriseFormUnmount: PropTypes.func
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
