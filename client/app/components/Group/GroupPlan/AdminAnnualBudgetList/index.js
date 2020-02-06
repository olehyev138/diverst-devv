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
  Button, Card, CardContent, CardActions,
  Typography, Grid, Link, TablePagination, Collapse, Box, MenuItem,
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import LoopIcon from '@material-ui/icons/Loop';
import RedoIcon from '@material-ui/icons/Redo';
import EditIcon from '@material-ui/icons/Edit';

import DiverstTable from 'components/Shared/DiverstTable';
import DiverstDropdownMenu from 'components/Shared/DiverstDropdownMenu';
import { injectIntl, intlShape } from 'react-intl';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Group/GroupPlan/AnnualBudget/messages';
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
      title: intl.formatMessage(listMessages.columns.group),
      field: 'name',
      query_field: 'name'
    },
    {
      title: intl.formatMessage(listMessages.columns.budget),
      field: 'annual_budget',
      sorting: false,
      render: rowData => rowData.annual_budget || intl.formatMessage(listMessages.notSet),
    },
    {
      title: intl.formatMessage(listMessages.columns.leftover),
      field: 'annual_budget_leftover',
      sorting: false,
      render: rowData => rowData.annual_budget_leftover || '$0.00'
    },
    {
      title: intl.formatMessage(listMessages.columns.approved),
      field: 'annual_budget_approved',
      sorting: false,
      render: rowData => rowData.annual_budget_approved || '$0.00'
    },
  ];

  const actions = [];

  actions.push({
    icon: () => <EditIcon />,
    tooltip: <DiverstFormattedMessage {...listMessages.actions.edit} />,
    onClick: (_, rowData) => {
      props.handleVisitEditPage(rowData.id);
    }
  });

  actions.push({
    icon: () => <RedoIcon />,
    tooltip: <DiverstFormattedMessage {...listMessages.actions.carryover} />,
    onClick: (_, rowData) => {
      /* eslint-disable-next-line no-alert, no-restricted-globals */
      if (confirm('Are you sure you want to carryover the budget over.\n This cannot be undone'))
        props.carryBudget(rowData.id);
    }
  });

  actions.push({
    icon: () => <LoopIcon />,
    tooltip: <DiverstFormattedMessage {...listMessages.actions.reset} />,
    onClick: (_, rowData) => {
      /* eslint-disable-next-line no-alert, no-restricted-globals */
      if (confirm('Are you sure you want to rest the budget over.\n This cannot be undone'))
        props.resetBudget(rowData.id);
    }
  });

  return (
    <React.Fragment>
      <Grid container spacing={3}>
        <Grid item xs>
          <DiverstTable
            title={intl.formatMessage(listMessages.title)}
            handlePagination={props.handlePagination}
            onOrderChange={handleOrderChange}
            isLoading={props.isFetchingAnnualBudgets}
            rowsPerPage={10}
            dataArray={Object.values(props.annualBudgets)}
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
  annualBudgets: PropTypes.object,
  annualBudgetTotal: PropTypes.number,
  isFetchingAnnualBudgets: PropTypes.bool,
  deleteAnnualBudgetBegin: PropTypes.func,
  handlePagination: PropTypes.func,
  handleOrdering: PropTypes.func,
  handleVisitAnnualBudgetEdit: PropTypes.func,
  handleChangeScope: PropTypes.func,
  carryBudget: PropTypes.func,
  resetBudget: PropTypes.func,
  handleVisitEditPage: PropTypes.func,
  annualBudgetType: PropTypes.string,
  links: PropTypes.shape({
    annualBudgetNew: PropTypes.string,
    annualBudgetEdit: PropTypes.func
  })
};

export default compose(
  memo,
  withStyles(styles),
  injectIntl,
)(AnnualBudgetList);
