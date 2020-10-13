/**
 *
 * Group Leaders List Component
 *
 */

import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import { Box, Button, Grid } from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import WrappedNavLink from 'components/Shared/WrappedNavLink';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Group/GroupManage/messages';
import EditIcon from '@material-ui/icons/Edit';
import DeleteIcon from '@material-ui/icons/DeleteOutline';
import AddIcon from '@material-ui/icons/Add';

import DiverstTable from 'components/Shared/DiverstTable';
import { injectIntl, intlShape } from 'react-intl';
import Permission from 'components/Shared/DiverstPermission';
import { permission } from 'utils/permissionsHelpers';

const styles = theme => ({
  errorButton: {
    color: theme.palette.error.main,
  },
});

export function GroupLeadersList(props) {
  const { classes, links, intl } = props;

  const columns = [
    { title: intl.formatMessage(messages.leader.column_name), field: 'user.name', query_field: 'users.last_name' },
    { title: intl.formatMessage(messages.leader.column_position), field: 'position_name', query_field: 'position_name' }
  ];

  const actions = [];
  if (permission(props.group, 'leaders_manage?')) {
    actions.push({
      icon: () => <EditIcon />,
      tooltip: intl.formatMessage(messages.leader.edit),
      onClick: (_, rowData) => {
        props.handleVisitGroupLeaderEdit(rowData.group_id, rowData.id);
      }
    });
    actions.push({
      icon: () => <DeleteIcon />,
      tooltip: intl.formatMessage(messages.leader.delete),
      onClick: (_, rowData) => {
        /* eslint-disable-next-line no-alert, no-restricted-globals */
        if (confirm('Are you sure you want to delete this group leader?'))
          props.deleteGroupLeaderBegin({ group_id: rowData.group_id, id: rowData.id });
      }
    });
  }

  const handleOrderChange = (columnId, orderDir) => {
    props.handleOrdering({
      orderBy: (columnId === -1) ? 'group_leaders.id' : `${columns[columnId].query_field}`,
      orderDir: (columnId === -1) ? 'asc' : orderDir
    });
  };

  return (
    <React.Fragment>
      <Permission show={permission(props.group, 'leaders_create?')}>
        <Grid container spacing={3} justify='flex-end'>
          <Grid item>
            <Button
              variant='contained'
              to={links.groupLeaderNew}
              color='primary'
              size='large'
              component={WrappedNavLink}
              startIcon={<AddIcon />}
            >
              {<DiverstFormattedMessage {...messages.leader.new} />}
            </Button>
          </Grid>
        </Grid>
      </Permission>
      <Box mb={1} />
      <Grid container spacing={3}>
        <Grid item xs>
          <DiverstTable
            title={intl.formatMessage(messages.leader.title)}
            onOrderChange={handleOrderChange}
            handlePagination={props.handlePagination}
            isLoading={props.isFetchingGroupLeaders}
            dataArray={props.groupLeaderList}
            dataTotal={props.groupLeaderTotal}
            columns={columns}
            rowsPerPage={props.params.count}
            actions={actions}
          />
        </Grid>
      </Grid>
    </React.Fragment>
  );
}

GroupLeadersList.propTypes = {
  intl: intlShape.isRequired,
  classes: PropTypes.object,
  group: PropTypes.object,
  deleteGroupLeaderBegin: PropTypes.func,
  links: PropTypes.shape({
    groupLeaderNew: PropTypes.string,
  }),
  params: PropTypes.object,
  groupLeaderList: PropTypes.array,
  groupLeaderTotal: PropTypes.number,
  isFetchingGroupLeaders: PropTypes.bool,
  handlePagination: PropTypes.func,
  handleOrdering: PropTypes.func,
  isFormLoading: PropTypes.bool,
  edit: PropTypes.bool,
  groupLeader: PropTypes.object,
  handleVisitGroupLeaderEdit: PropTypes.func,
};

export default compose(
  injectIntl,
  memo,
  withStyles(styles)
)(GroupLeadersList);
