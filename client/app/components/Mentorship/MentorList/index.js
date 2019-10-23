/**
 *
 * UserList Component
 *
 *
 */

import React, {
  memo, useEffect, useRef, useState
} from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import {
  Button, Card, CardContent, CardActions,
  Typography, Grid, Link, TablePagination, Collapse, Box,
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/User/messages';
import WrappedNavLink from 'components/Shared/WrappedNavLink';

import AddIcon from '@material-ui/icons/Add';
import DeleteIcon from '@material-ui/icons/DeleteOutline';
import EditIcon from '@material-ui/icons/Edit';

import DiverstTable from 'components/Shared/DiverstTable';
import DiverstLoader from "../../Shared/DiverstLoader";
import DiverstPagination from "../../Shared/DiverstPagination";


const styles = theme => ({
  userListItem: {
    width: '100%',
  },
  userListItemDescription: {
    paddingTop: 8,
  },
  errorButton: {
    color: theme.palette.error.main,
  },
});

export function UserList(props, context) {
  // const { classes } = props;
  // const [expandedUsers, setExpandedUsers] = useState({});
  //
  // const [userForm, setUserForm] = useState(undefined);

  const columns = [
    { title: 'First Name', field: 'first_name' },
    { title: 'Last Name', field: 'last_name' }
  ];

  return (
    <React.Fragment>
      <Grid container spacing={3} justify='flex-end'>
        <Grid item>
          <Button
            variant='contained'
            color='primary'
            size='large'
            to={props.links.userNew}
            component={WrappedNavLink}
            startIcon={<AddIcon />}
          >
            <DiverstFormattedMessage {...messages.new} />
          </Button>
        </Grid>
      </Grid>
      <Box mb={1} />
      <DiverstLoader isLoading={props.isFetchingMentors}>
        <Grid container>
          { /* eslint-disable-next-line arrow-body-style */ }
          {props.mentors && props.mentors.map((item, i) => {
            return (
              <Grid item key={item.id}>
                <Grid container>
                  <Grid item xs>
                    {item.first_name}
                  </Grid>
                  <Grid item xs>
                    {item.last_name}
                  </Grid>
                </Grid>
                <Box mb={3} />
              </Grid>
            );
          })}
        </Grid>
      </DiverstLoader>
      <DiverstPagination
        isLoading={props.isFetchingMentors}
        rowsPerPage={props.mentorParams.count}
        count={props.mentorTotal}
        handlePagination={props.handleMentorPagination}
      />
    </React.Fragment>
  );
}

UserList.propTypes = {
  classes: PropTypes.object,
  mentors: PropTypes.array,
  mentorTotal: PropTypes.number,
  isFetchingMentors: PropTypes.bool,
  mentorParams: PropTypes.object,
  handleMentorPagination: PropTypes.func,
  handleMentorOrdering: PropTypes.func,
  links: PropTypes.shape({
    userNew: PropTypes.string,
    userEdit: PropTypes.func
  })
};

export default compose(
  memo,
  withStyles(styles),
)(UserList);
