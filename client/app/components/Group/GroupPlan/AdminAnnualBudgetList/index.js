/**
 *
 * AnnualBudgetList Component
 *
 *
 */

import React, {
  memo, useMemo, useCallback
} from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import {
  Grid, Button, Box
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
import Permission from 'components/Shared/DiverstPermission';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';

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
  buttons: {
    float: 'right',
  },
});

export function AnnualBudgetList(props, context) {
  const { classes, intl } = props;

  const budgetPeriodObject = useMemo(
    () => ({ year: props.budgetPeriod?.[0], quarter: props.budgetPeriod?.[1] }),
    [props.budgetPeriod]
  );

  const handleOrderChange = (columnId, orderDir) => {
    props.handleOrdering({
      orderBy: (columnId === -1) ? 'id' : `${columns[columnId].query_field}`,
      orderDir: (columnId === -1) ? 'asc' : orderDir
    });
  };

  const annualRowRender = useCallback(
    rowData => rowData.annual_budget ? toCurrencyString(props.intl, rowData.annual_budget) : intl.formatMessage(listMessages.notSet, props.customTexts),
    [props.intl]
  );

  const leftoverRowRender = useCallback(
    rowData => toCurrencyString(props.intl, rowData.annual_budget_leftover || 0, rowData.currency),
    [props.intl]
  );

  const approvedRowRender = useCallback(
    rowData => toCurrencyString(props.intl, rowData.annual_budget_approved || 0, rowData.currency),
    [props.intl]
  );

  const rowStyle = useCallback(
    (value, rowData) => (props.budgetType !== 'region' || rowData.parent_coded_id) ? {} : { fontWeight: 'bold' },
    [props.budgetType]
  );

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
      cellStyle: rowStyle,
      render: annualRowRender,
    },
    {
      title: intl.formatMessage(listMessages.columns.leftover, props.customTexts),
      field: 'annual_budget_leftover',
      sorting: false,
      cellStyle: rowStyle,
      render: leftoverRowRender
    },
    {
      title: intl.formatMessage(listMessages.columns.approved, props.customTexts),
      field: 'annual_budget_approved',
      sorting: false,
      cellStyle: rowStyle,
      render: approvedRowRender
    },
  ];

  const actions = [];

  actions.push(
    rowData => ({
      icon: () => <EditIcon />,
      tooltip: intl.formatMessage(listMessages.actions.edit, props.customTexts),
      onClick: (_, rowData) => {
        props.handleVisitEditPage(rowData.budget_manager_id);
      },
      disabled: !permission(rowData, 'annual_budgets_manage?')
    })
  );

  return (
    <React.Fragment>
      <Permission show={permission(props, 'manage_all_budgets')}>
        <Grid container alignContent='flex-end' alignItems='flex-end'>
          <Grid item xs>
            <Button
              onClick={() => props.resetAll()}
              color='primary'
              variant='contained'
              className={classes.buttons}
              disabled={props.budgetPeriod[0] == null}
            >
              { props.budgetPeriod?.[1]
                ? <DiverstFormattedMessage {...messages.adminList.initializeQuarter} />
                : <DiverstFormattedMessage {...messages.adminList.initializeYear} /> }
            </Button>
          </Grid>
        </Grid>
        <Box mb={2} />
      </Permission>
      <Grid container spacing={3}>
        <Grid item xs>
          <DiverstTable
            title={listMessages.title(...props.budgetPeriod)}
            extraTitleProps={budgetPeriodObject}
            handlePagination={props.handlePagination}
            onOrderChange={handleOrderChange}
            handleSearching={props.handleSearching}
            isLoading={props.isFetchingAnnualBudgets}
            rowsPerPage={10}
            dataArray={props.annualBudgets}
            dataTotal={props.annualBudgetTotal}
            columns={columns}
            actions={actions}
            parentChildData={(row, rows) => row.coded_id && rows.find(a => a.coded_id === row.parent_coded_id)}
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
  resetAll: PropTypes.func,
  handleVisitEditPage: PropTypes.func,
  annualBudgetType: PropTypes.string,
  budgetPeriod: PropTypes.array.isRequired,
  budgetType: PropTypes.string,
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
