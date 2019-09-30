/**
 *
 * Outcomes List Component
 *
 */

import React, { memo, useContext, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import withStyles from '@material-ui/core/styles/withStyles';

import {
  Grid, Card, CardContent, Typography, CardActions, Button, Divider, Box,
} from '@material-ui/core';

import { FormattedMessage } from 'react-intl';
import messages from 'containers/Group/Outcome/messages';
import WrappedNavLink from 'components/Shared/WrappedNavLink';

import ListItemIcon from '@material-ui/icons/Remove';
import EventIcon from '@material-ui/icons/Event';

import Pagination from 'components/Shared/Pagination';

const styles = theme => ({
  errorButton: {
    color: theme.palette.error.main,
  },
  buttonIcon: {
    paddingRight: 4,
  }
});

export function OutcomesList(props, context) {
  const { classes, intl } = props;

  const [page, setPage] = useState(props.defaultParams.page);
  const [rowsPerPage, setRowsPerPage] = useState(props.defaultParams.count);

  const handleChangePage = (event, newPage) => {
    setPage(newPage);
    props.handlePagination({
      count: rowsPerPage,
      page: newPage
    });
  };

  const handleChangeRowsPerPage = (event) => {
    setRowsPerPage(+event.target.value);
    props.handlePagination({
      count: +event.target.value,
      page
    });
  };

  return (
    <React.Fragment>
      <Grid container spacing={3} justify='flex-end'>
        <Grid item>
          <Button
            variant='contained'
            to={props.links.outcomeNew}
            color='primary'
            size='large'
            component={WrappedNavLink}
          >
            <FormattedMessage {...messages.new} />
          </Button>
        </Grid>
      </Grid>
      <Box mb={2} />
      <Grid container>
        { /* eslint-disable-next-line arrow-body-style */}
        {props.outcomes && props.outcomes.map((outcome, i) => (
          <Grid item key={outcome.id} xs={12}>
            <Card>
              <CardContent>
                <Typography
                  color='primary'
                  variant='h6'
                  gutterBottom
                >
                  {outcome.name}
                </Typography>
                <Box mb={1} mt={2}>
                  <Typography color='secondary'>
                    <FormattedMessage {...messages.pillars.text} />
                  </Typography>
                  <Divider />
                </Box>
                {outcome.pillars && outcome.pillars.map((pillar, i) => (
                  <React.Fragment key={pillar.id}>
                    <Typography gutterBottom>
                      <ListItemIcon color='secondary' />
                      {pillar.name}
                    </Typography>
                  </React.Fragment>
                ))}
                {(!outcome.pillars || outcome.pillars.length <= 0) && (
                  <Typography>
                    <FormattedMessage {...messages.empty} />
                  </Typography>
                )}
              </CardContent>
              <CardActions>
                <Button
                  component={WrappedNavLink}
                  color='primary'
                  to={props.links.outcomeShow(outcome.id)}
                >
                  <EventIcon className={classes.buttonIcon} />
                  Events
                </Button>
                <Button
                  component={WrappedNavLink}
                  color='secondary'
                  to={props.links.outcomeEdit(outcome.id)}
                >
                  Edit
                </Button>
                <Button
                  className={classes.errorButton}
                  onClick={() => {
                    /* eslint-disable-next-line no-alert, no-restricted-globals */
                    if (confirm('Delete outcome?'))
                      props.deleteOutcomeBegin(outcome);
                  }}
                >
                  Delete
                </Button>
              </CardActions>
            </Card>
            <Box mb={3} />
          </Grid>
        ))}
      </Grid>
      <Pagination
        page={page}
        rowsPerPage={rowsPerPage}
        count={props.outcomeTotal}
        onChangePage={handleChangePage}
        onChangeRowsPerPage={handleChangeRowsPerPage}
      />
    </React.Fragment>
  );
}

OutcomesList.propTypes = {
  intl: PropTypes.object,
  classes: PropTypes.object,
  outcomes: PropTypes.array,
  outcomeTotal: PropTypes.number,
  defaultParams: PropTypes.object,
  handlePagination: PropTypes.func,
  links: PropTypes.object,
  deleteOutcomeBegin: PropTypes.func.isRequired,
};

export default compose(
  memo,
  withStyles(styles)
)(OutcomesList);
