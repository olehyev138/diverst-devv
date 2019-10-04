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
  Grid, Card, CardContent, Typography, Link, CardActions, Button, Divider, Box,
} from '@material-ui/core';

import { FormattedMessage } from 'react-intl';
import messages from 'containers/Group/Outcome/messages';
import WrappedNavLink from 'components/Shared/WrappedNavLink';

import ListItemIcon from '@material-ui/icons/Remove';
import AddIcon from '@material-ui/icons/Add';

import Pagination from 'components/Shared/Pagination';

const styles = theme => ({
  floatRight: {
    float: 'right',
    marginBottom: 24,
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
      <Button
        className={classes.floatRight}
        variant='contained'
        to={props.links.outcomeNew}
        color='primary'
        size='large'
        component={WrappedNavLink}
        startIcon={<AddIcon />}
      >
        <FormattedMessage {...messages.new} />
      </Button>
      <Grid container>
        { /* eslint-disable-next-line arrow-body-style */}
        {props.outcomes && props.outcomes.map((outcome, i) => (
          <Grid item key={outcome.id} xs={12}>
            <Card>
              <CardContent>
                <Typography variant='h6' gutterBottom>
                  {outcome.name}
                </Typography>
                <Box mb={1} mt={2}>
                  <Typography color='textSecondary'>
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
                    There are no pillars for this outcome.
                  </Typography>
                )}
              </CardContent>
              <CardActions>
                <Button
                  component={WrappedNavLink}
                  color='primary'
                  to={props.links.outcomeEdit(outcome.id)}
                >
                  Manage
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
};

export default compose(
  memo,
  withStyles(styles)
)(OutcomesList);
