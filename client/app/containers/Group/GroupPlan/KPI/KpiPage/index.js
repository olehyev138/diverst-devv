import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect';
import { compose } from 'redux';

import KPILayout from 'containers/Layouts/GroupPlanLayout/KPILayout';

import Kpi from 'components/Group/GroupPlan/KpiMetrics';

export function KpiPage(props) {
  const links = {};

  const { isLoading } = props;

  return (
    <Kpi />
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
