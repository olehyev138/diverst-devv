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
import { NavLink } from 'react-router-dom';
import PropTypes from 'prop-types';
import { RouteContext } from 'containers/Layouts/ApplicationLayout';

import {
  Button, Card, CardActions, CardContent, Collapse, Grid, Link,
  TablePagination, Typography
} from '@material-ui/core/index';
import { withStyles } from '@material-ui/core/styles';

import MaterialTable from 'material-table';
import tableIcons from 'utils/tableIcons';

import { ROUTES } from 'containers/Shared/Routes/constants';
import WrappedNavLink from 'components/Shared/WrappedNavLink';

import { FormattedMessage } from 'react-intl';
import messages from 'containers/Group/GroupMembers/messages';
import buildDataFunction from 'utils/dataTableHelper';

const styles = theme => ({
  errorButton: {
    color: theme.palette.error.main,
  },
});

export function GroupMemberList(props) {
  const { classes } = props;
  const [page, setPage] = useState(0);
  const [rowsPerPage, setRowsPerPage] = useState(5);

  /* MaterialTable pagination handlers (defined differently then MaterialUI pagination) */
  const handleChangePage = (newPage) => {
    setPage(newPage);
    props.handlePagination({ count: rowsPerPage, page: newPage });
  };

  const handleChangeRowsPerPage = (pageSize) => {
    setRowsPerPage(+pageSize);
    props.handlePagination({ count: +pageSize, page });
  };

  /* Store reference to table & use to refresh table when data changes */
  const ref = useRef();
  useEffect(() => ref.current && ref.current.onQueryChange(), [props.memberList]);

  return (
    <React.Fragment>
      <Grid container spacing={3}>
        <Grid item>
          <Button
            variant='contained'
            to={props.links.groupMembersNew}
            color='primary'
            size='large'
            component={WrappedNavLink}
          >
            <FormattedMessage {...messages.new} />
          </Button>
        </Grid>
        <Grid item>
          <Button
            variant='contained'
            to='#'
            color='primary'
            size='large'
            component={WrappedNavLink}
          >
            <FormattedMessage {...messages.export} />
          </Button>
        </Grid>
        <Grid item xs={12}>
          <MaterialTable
            tableRef={ref}
            icons={tableIcons}
            title='Members'
            onChangePage={handleChangePage}
            onChangeRowsPerPage={handleChangeRowsPerPage}
            columns={[
              { title: 'First Name', field: 'first_name' },
              { title: 'Last Name', field: 'last_name' }
            ]}
            data={buildDataFunction(props.memberList, page, props.memberTotal)}
          />
        </Grid>
      </Grid>
    </React.Fragment>
  );
}

GroupMemberList.propTypes = {
  classes: PropTypes.object,
  deleteMemberBegin: PropTypes.func,
  links: PropTypes.shape({
    groupMembersNew: PropTypes.string,
  }),
  memberList: PropTypes.array,
  memberTotal: PropTypes.number,
  groupId: PropTypes.string,
  handlePagination: PropTypes.func
};

export default compose(
  memo,
  withStyles(styles)
)(GroupMemberList);
