/**
 *
 * Budget Overview Form Component
 *
 */

import React, {
  memo, useRef, useState, useEffect
} from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';
import { withStyles } from '@material-ui/core/styles';

import {
  Box
} from '@material-ui/core';

import { injectIntl, intlShape } from 'react-intl';
import DiverstLoader from 'components/Shared/DiverstLoader';
import AnnualBudgetListItem from '../AnnualBudgetListItem';
import DiverstPagination from 'components/Shared/DiverstPagination';

const styles = theme => ({
  noBottomPadding: {
    paddingBottom: '0 !important',
  },
});

export function AnnualBudgetList(props) {
  const {
    annualBudgetsTotal,
    annualBudgets,
    isLoading,
    defaultParams,
    handlePagination,
    links,
    initiatives,
    initiativesTotals,
    initiativesLoading,
    handleInitiativePagination,
    handleInitiativeOrdering,
  } = props;

  return (
    <React.Fragment>
      <DiverstLoader isLoading={isLoading}>
        {annualBudgets.map(annualBudget => (
          <React.Fragment key={annualBudget.id}>
            <AnnualBudgetListItem
              item={annualBudget}
              links={links}
              initiatives={initiatives[annualBudget.id]}
              initiativesTotal={initiativesTotals[annualBudget.id]}
              initiativesLoading={initiativesLoading[annualBudget.id]}
              handlePagination={handleInitiativePagination(annualBudget.id)}
              handleOrdering={handleInitiativeOrdering(annualBudget.id)}
            />
            <Box mb={2} />
          </React.Fragment>
        ))}
      </DiverstLoader>
      <DiverstPagination
        isLoading={isLoading}
        rowsPerPage={defaultParams.count}
        count={annualBudgetsTotal}
        handlePagination={handlePagination}
      />
    </React.Fragment>
  );
}

AnnualBudgetList.propTypes = {
  annualBudgets: PropTypes.array,
  annualBudgetsTotal: PropTypes.number,
  initiatives: PropTypes.object,
  initiativesTotals: PropTypes.object,
  initiativesLoading: PropTypes.object,
  group: PropTypes.object,
  handlePagination: PropTypes.func,
  handleInitiativePagination: PropTypes.func,
  handleInitiativeOrdering: PropTypes.func,
  defaultParams: PropTypes.object,
  links: PropTypes.object,
  isLoading: PropTypes.bool,
};

export default compose(
  injectIntl,
  memo,
  withStyles(styles)
)(AnnualBudgetList);
