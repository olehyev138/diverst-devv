/**
 *
 * Group Member List Component
 *
 */

import React, {
  forwardRef, memo, useState, useContext
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

const styles = theme => ({
  errorButton: {
    color: theme.palette.error.main,
  },
});

export function GroupMemberList(props) {
  const { classes } = props;
  const [page, setPage] = useState(0);
  const [rowsPerPage, setRowsPerPage] = useState(5);

  const handleChangePage = (event, newPage) => {
    setPage(newPage);
    // props.handlePagination({ count: rowsPerPage, page: newPage });
  };

  const handleChangeRowsPerPage = (event) => {
    setRowsPerPage(+event.target.value);
    // props.handlePagination({ count: +event.target.value, page });
  };

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
          {props.memberList && Object.values(props.memberList).map((user, i) => (
            /* eslint-disable-next-line react/jsx-wrap-multilines */
            <Card key={user.id}>
              <CardContent>
                {/* eslint-disable-next-line jsx-a11y/anchor-is-valid */}
                <Link href='#'>
                  <Typography variant='h5' component='h2' display='inline'>
                    {`${user.first_name} ${user.last_name}`}
                  </Typography>
                </Link>
              </CardContent>
              <CardActions>
                <Button
                  size='small'
                  className={classes.errorButton}
                  onClick={() => {
                    /* eslint-disable-next-line no-alert, no-restricted-globals */
                    if (confirm('Delete group?'))
                      props.deleteMemberBegin({ userId: user.id, groupId: props.groupId });
                  }}
                >
                  <FormattedMessage {...messages.delete} />
                </Button>
              </CardActions>
            </Card>))
          }
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
  memberList: PropTypes.object,
  memberTotal: PropTypes.number,
  groupId: PropTypes.string
};

export default compose(
  memo,
  withStyles(styles)
)(GroupMemberList);
