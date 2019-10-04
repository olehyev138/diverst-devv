/**
 *
 * Group Member List Component
 *
 */

import React, {
  forwardRef, memo, useState,
  useEffect, useRef
} from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import {
  Button, Card, CardActions, CardContent, Collapse, Grid, Link,
  TablePagination, Typography, Box
} from '@material-ui/core/index';
import { withStyles } from '@material-ui/core/styles';

import MaterialTable from 'material-table';
import tableIcons from 'utils/tableIcons';

import WrappedNavLink from 'components/Shared/WrappedNavLink';

import { FormattedMessage } from 'react-intl';
import messages from 'containers/Group/GroupMembers/messages';
import buildDataFunction from 'utils/dataTableHelper';

import DeleteOutline from '@material-ui/icons/DeleteOutline';
import AddIcon from '@material-ui/icons/Add';
import ExportIcon from '@material-ui/icons/SaveAlt';

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
  const [page, setPage] = useState(props.params.page);
  const [rowsPerPage, setRowsPerPage] = useState(props.params.count);

  /* MaterialTable pagination handlers (defined differently then MaterialUI pagination) */
  const handleChangePage = (newPage) => {
    setPage(newPage);
    props.handlePagination({ count: rowsPerPage, page: newPage });
  };

  const handleChangeRowsPerPage = (pageSize) => {
    setRowsPerPage(+pageSize);
    props.handlePagination({ count: +pageSize, page });
  };

  const handleOrderChange = (columnId, orderDir) => {
    props.handleOrdering({
      orderBy: (columnId === -1) ? 'users.id' : `users.${columns[columnId].field}`,
      orderDir: (columnId === -1) ? 'asc' : orderDir
    });
  };

  const columns = [
    { title: 'First Name', field: 'first_name' },
    { title: 'Last Name', field: 'last_name' }
  ];

  /* Store reference to table & use to refresh table when data changes */
  const ref = useRef();
  useEffect(() => ref.current && ref.current.onQueryChange(), [props.memberList]);

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
          <FormattedMessage {...messages.new} />
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
          <FormattedMessage {...messages.export} />
        </Button>
      </Box>
      <Box className={classes.floatSpacer} />
      <MaterialTable
        tableRef={ref}
        icons={tableIcons}
        title='Members'
        isLoading={props.isFetchingMembers}
        onChangePage={handleChangePage}
        onChangeRowsPerPage={handleChangeRowsPerPage}
        onOrderChange={handleOrderChange}
        data={buildDataFunction(props.memberList, page, props.memberTotal)}
        columns={columns}
        actions={[{
          icon: () => <DeleteOutline />,
          tooltip: 'Delete Member',
          onClick: (_, rowData) => {
            /* eslint-disable-next-line no-alert, no-restricted-globals */
            if (confirm('Delete member?'))
              props.deleteMemberBegin({ userId: rowData.id, groupId: props.groupId });
          }
        }]}
        options={{
          actionsColumnIndex: -1,
          pageSize: rowsPerPage,
        }}
      />
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
  handleOrdering: PropTypes.func
};

export default compose(
  memo,
  withStyles(styles)
)(GroupMemberList);
