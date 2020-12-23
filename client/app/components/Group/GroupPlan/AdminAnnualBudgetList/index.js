/**
 *
 * AnnualBudgetList Component
 *
 *
 */

import React, {
  memo
} from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import {
  Grid,
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import LoopIcon from '@material-ui/icons/Loop';
import RedoIcon from '@material-ui/icons/Redo';
import EditIcon from '@material-ui/icons/Edit';

import DiverstTable from 'components/Shared/DiverstTable';
import { injectIntl, intlShape } from 'react-intl';
import messages from 'containers/Group/GroupPlan/AnnualBudget/messages';
import { permission } from 'utils/permissionsHelpers';
import { toCurrencyString } from 'utils/currencyHelpers';
import DiverstFormattedMessage from '../../../Shared/DiverstFormattedMessage';

const { adminList: listMessages } = messages;

const styles = theme => ({
  annualBudgetListItem: {
    width: '100%',
  },
  annualBudgetListItemDescription: {
    paddingTop: 8,
  },
  errorButton: {
    color: theme.palette.error.main,
  },
});

export function AnnualBudgetList(props, context) {
  const { classes, intl } = props;

  const handleOrderChange = (columnId, orderDir) => {
    props.handleOrdering({
      orderBy: (columnId === -1) ? 'id' : `${columns[columnId].query_field}`,
      orderDir: (columnId === -1) ? 'asc' : orderDir
    });
  };

  const columns = [
    {
      title: intl.formatMessage(listMessages.columns.group, props.customTexts),
      field: 'name',
      query_field: 'name'
    },
    {
      title: intl.formatMessage(listMessages.columns.budget, props.customTexts),
      field: 'annual_budget',
      sorting: false,
      render: rowData => rowData.annual_budget ? toCurrencyString(props.intl, rowData.annual_budget) : intl.formatMessage(listMessages.notSet, props.customTexts),
    },
    {
      title: intl.formatMessage(listMessages.columns.leftover, props.customTexts),
      field: 'annual_budget_leftover',
      sorting: false,
      render: rowData => toCurrencyString(props.intl, rowData.annual_budget_leftover || 0, rowData.currency)
    },
    {
      title: intl.formatMessage(listMessages.columns.approved, props.customTexts),
      field: 'annual_budget_approved',
      sorting: false,
      render: rowData => toCurrencyString(props.intl, rowData.annual_budget_approved || 0, rowData.currency)
    },
  ];

  const actions = [];

  actions.push(
    rowData => ({
      icon: () => <EditIcon />,
      tooltip: intl.formatMessage(listMessages.actions.edit, props.customTexts),
      onClick: (_, rowData) => {
        props.handleVisitEditPage(rowData.id);
      },
      disabled: !permission(rowData, 'annual_budgets_manage?')
    })
  );

  actions.push(
    rowData => ({
      icon: () => <RedoIcon />,
      tooltip: <DiverstFormattedMessage {...listMessages.actions.carryover} />,
      onClick: (_, rowData) => {
        /* eslint-disable-next-line no-alert, no-restricted-globals */
        if (confirm(intl.formatMessage(messages.carryoverConfirm, props.customTexts)))
          props.carryBudget(rowData.id);
      },
      // disabled: !permission(rowData, 'carryover_annual_budget?')
    })
  );

  actions.push(
    rowData => ({
      icon: () => <LoopIcon />,
      tooltip: <DiverstFormattedMessage {...listMessages.actions.reset} />,
      onClick: (_, rowData) => {
        /* eslint-disable-next-line no-alert, no-restricted-globals */
        if (confirm(intl.formatMessage(messages.resetConfirm, props.customTexts)))
          props.resetBudget(rowData.id);
      },
      // disabled: !permission(rowData, 'reset_annual_budget?')
    })
  );

  return (
    <React.Fragment>
      <Grid container spacing={3}>
        <Grid item xs>
          <DiverstTable
            title={listMessages.title}
            handlePagination={props.handlePagination}
            onOrderChange={handleOrderChange}
            handleSearching={props.handleSearching}
            isLoading={props.isFetchingAnnualBudgets}
            rowsPerPage={10}
            dataArray={props.annualBudgets}
            dataTotal={props.annualBudgetTotal}
            columns={columns}
            actions={actions}
            parentChildData={(row, rows) => rows.find(a => a.id === row.parent_id)}
          />
        </Grid>
      </Grid>
    </React.Fragment>
  );
}

AnnualBudgetList.propTypes = {
  intl: intlShape.isRequired,
  classes: PropTypes.object,
  annualBudgets: PropTypes.array,
  annualBudgetTotal: PropTypes.number,
  isFetchingAnnualBudgets: PropTypes.bool,
  deleteAnnualBudgetBegin: PropTypes.func,
  handlePagination: PropTypes.func,
  handleOrdering: PropTypes.func,
  handleSearching: PropTypes.func,
  handleVisitAnnualBudgetEdit: PropTypes.func,
  handleChangeScope: PropTypes.func,
  carryBudget: PropTypes.func,
  resetBudget: PropTypes.func,
  handleVisitEditPage: PropTypes.func,
  annualBudgetType: PropTypes.string,
  links: PropTypes.shape({
    annualBudgetNew: PropTypes.string,
    annualBudgetEdit: PropTypes.func
  }),
  customTexts: PropTypes.object,
};

export default compose(
  memo,
  withStyles(styles),
  injectIntl,
)(AnnualBudgetList);
