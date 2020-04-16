/**
 *
 * Templates List Component
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import withStyles from '@material-ui/core/styles/withStyles';

import {
  Box, Card, CardContent, Grid, Link, Typography, Paper
} from '@material-ui/core';

import messages from 'containers/GlobalSettings/Email/Email/messages';

import EditIcon from '@material-ui/icons/Edit';
import DiverstTable from 'components/Shared/DiverstTable';
import { permission } from 'utils/permissionsHelpers';

const styles = theme => ({
  emailListItem: {
    width: '100%',
  },
  arrowRight: {
    color: theme.custom.colors.grey,
  },
  divider: {
    color: theme.custom.colors.lightGrey,
    backgroundColor: theme.custom.colors.lightGrey,
    border: 'none',
    height: '1px',
  },
  emailLink: {
    '&:hover': {
      textDecoration: 'none',
    },
    '&:hover h2': {
      textDecoration: 'underline',
    },
  },
  dateText: {
    fontWeight: 'bold',
  },
  floatRight: {
    float: 'right',
  },
  floatSpacer: {
    display: 'flex',
    width: '100%',
    marginBottom: 24,
  },
});

const columns = [
  {
    title: 'Name',
    field: 'name',
    query_field: 'name'
  },
];

export function TemplatesList(props) {
  const { classes } = props;

  const actions = [
    rowData => ({
      icon: () => <EditIcon />,
      tooltip: 'Edit Permissions',
      onClick: (_, rowData) => {
        props.handlePolicyEdit(rowData.id);
      },
      disabled: !permission(rowData, 'update?')
    })
  ];

  const handleOrderChange = (columnId, orderDir) => {
    props.handleOrdering({
      orderBy: (columnId === -1) ? 'id' : `${columns[columnId].query_field}`,
      orderDir: (columnId === -1) ? 'asc' : orderDir
    });
  };

  return (
    <React.Fragment>
      <CardContent>
        <DiverstTable
          title='Policies'
          handlePagination={props.handlePagination}
          onOrderChange={handleOrderChange}
          isLoading={props.isLoading}
          rowsPerPage={5}
          params={props.params}
          dataArray={props.templates}
          dataTotal={props.templatesTotal}
          columns={columns}
          actions={actions}
        />
      </CardContent>
    </React.Fragment>
  );
}

TemplatesList.propTypes = {
  classes: PropTypes.object,
  templates: PropTypes.array,
  templatesTotal: PropTypes.number,
  isLoading: PropTypes.bool,
  handlePagination: PropTypes.func,
  handleOrdering: PropTypes.func,
  handlePolicyEdit: PropTypes.func,
  params: PropTypes.object,
};

export default compose(
  withStyles(styles),
  memo,
)(TemplatesList);
