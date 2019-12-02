/**
 *
 * Group Member List Component
 *
 */

import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import {
  Button, Box, MenuItem
} from '@material-ui/core/index';
import { withStyles } from '@material-ui/core/styles';

import WrappedNavLink from 'components/Shared/WrappedNavLink';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Group/GroupMembers/messages';

import DeleteIcon from '@material-ui/icons/DeleteOutline';
import AddIcon from '@material-ui/icons/Add';
import ExportIcon from '@material-ui/icons/SaveAlt';

import DiverstTable from 'components/Shared/DiverstTable';
import DiverstDropdownMenu from 'components/Shared/DiverstDropdownMenu';

const styles = theme => ({
  errorButton: {
    color: theme.palette.error.main,
  },
  actionButton: {
    marginRight: 12,
    marginBottom: 12,
  },
  floatRight: {
    float: 'right',
    marginBottom: 12,
  },
  floatSpacer: {
    display: 'flex',
    width: '100%',
    marginBottom: 24,
  },
});

export function GroupMemberList(props) {
  const { classes } = props;

  // MENU CODE
  const [anchor, setAnchor] = React.useState(null);

  const handleClick = (event) => {
    setAnchor(event.currentTarget);
  };
  const handleClose = (type) => {
    setAnchor(null);
    props.handleChangeTab(type);
  };

  const handleOrderChange = (columnId, orderDir) => {
    props.handleOrdering({
      orderBy: (columnId === -1) ? 'users.id' : `${columns[columnId].query_field}`,
      orderDir: (columnId === -1) ? 'asc' : orderDir
    });
  };

  const columns = [
    {
      title: 'First Name',
      field: 'user.first_name',
      query_field: 'users.first_name'
    },
    {
      title: 'Last Name',
      field: 'user.last_name',
      query_field: 'users.last_name'
    },
    {
      title: 'Membership Status',
      field: 'status',
      query_field: '(CASE WHEN users.active = false THEN \'inactive\' WHEN groups.pending_users AND accepted_member THEN \'pending\' ELSE \'active\' END)',
      sorting: true,
      lookup: {
        active: 'Active',
        inactive: 'Inactive',
        pending: 'Pending',
      }
    },
  ];

  return (
    <React.Fragment>
      <Box className={classes.floatRight}>
        <Button
          className={classes.actionButton}
          variant='contained'
          to={props.links.groupMembersNew}
          color='primary'
          size='large'
          component={WrappedNavLink}
          startIcon={<AddIcon />}
        >
          <DiverstFormattedMessage {...messages.new} />
        </Button>
        <Button
          className={classes.actionButton}
          variant='contained'
          to='#'
          color='secondary'
          size='large'
          component={WrappedNavLink}
          startIcon={<ExportIcon />}
        >
          <DiverstFormattedMessage {...messages.export} />
        </Button>
      </Box>
      <Box className={classes.floatRight}>
        <Button onClick={handleClick}>
          {props.memberType}
        </Button>
      </Box>
      <Box className={classes.floatSpacer} />
      <DiverstTable
        title='Members'
        handlePagination={props.handlePagination}
        isLoading={props.isFetchingMembers}
        onOrderChange={handleOrderChange}
        dataArray={props.memberList}
        dataTotal={props.memberTotal}
        columns={columns}
        rowsPerPage={props.params.count}
        actions={[{
          icon: () => <DeleteIcon />,
          tooltip: 'Delete Member',
          onClick: (_, rowData) => {
            /* eslint-disable-next-line no-alert, no-restricted-globals */
            if (confirm('Delete member?'))
              props.deleteMemberBegin({
                userId: rowData.id,
                groupId: props.groupId
              });
          }
        }]}
      />
      <DiverstDropdownMenu
        anchor={anchor}
        setAnchor={setAnchor}
      >
        <MenuItem onClick={() => handleClose('accepted_users')}>
          Active
        </MenuItem>
        <MenuItem onClick={() => handleClose('inactive')}>
          Inactive
        </MenuItem>
        <MenuItem onClick={() => handleClose('pending')}>
          Pending
        </MenuItem>
        <MenuItem onClick={() => handleClose('all')}>
          All
        </MenuItem>
      </DiverstDropdownMenu>
    </React.Fragment>
  );
}

GroupMemberList.propTypes = {
  classes: PropTypes.object,
  deleteMemberBegin: PropTypes.func,
  links: PropTypes.shape({
    groupMembersNew: PropTypes.string,
  }),
  params: PropTypes.object,
  memberList: PropTypes.array,
  memberTotal: PropTypes.number,
  isFetchingMembers: PropTypes.bool,
  groupId: PropTypes.string,
  handlePagination: PropTypes.func,
  handleOrdering: PropTypes.func,

  memberType: PropTypes.string.isRequired,
  MemberTypes: PropTypes.array.isRequired,
  setMemberType: PropTypes.func.isRequired,
  handleChangeTab: PropTypes.func.isRequired,
};

export default compose(
  memo,
  withStyles(styles)
)(GroupMemberList);
