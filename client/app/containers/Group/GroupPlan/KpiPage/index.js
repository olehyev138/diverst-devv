import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect';
import { compose } from 'redux';

import GroupPlanLayout from 'containers/Layouts/GroupPlanLayout';

import Kpi from 'components/Group/GroupPlan/Kpi';

export function KpiPage(props) {
  const links = {};

  const { isLoading } = props;

  return (
    <GroupPlanLayout
      component={() => (
        <Kpi />
      )}
      {...props}
    />
  );
}

KpiPage.propTypes = {
  isLoading: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({});

const mapDispatchToProps = {};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(KpiPage);
