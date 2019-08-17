/**
 *
 * Outcomes List Component
 *
 */

import React, { memo, useContext, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { RouteContext } from 'containers/Layouts/ApplicationLayout';
import withStyles from '@material-ui/core/styles/withStyles';

import {
  Grid, Card, CardContent, Typography, Link, CardActions, Button, Divider, Box, TablePagination,
} from '@material-ui/core';

import { FormattedMessage } from 'react-intl';
import messages from 'containers/Group/Outcome/messages';
import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { ROUTES } from 'containers/Shared/Routes/constants';

import ListItemIcon from '@material-ui/icons/Remove';

const styles = theme => ({});

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
      <Grid container spacing={3}>
        <Grid item xs={12}>
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
          </Grid>
        ))}
      </Grid>
      <TablePagination
        component='div'
        page={page}
        rowsPerPageOptions={[5, 10, 25]}
        rowsPerPage={rowsPerPage}
        count={props.outcomeTotal || 0}
        onChangePage={handleChangePage}
        onChangeRowsPerPage={handleChangeRowsPerPage}
        backIconButtonProps={{
          'aria-label': 'Previous Page',
        }}
        nextIconButtonProps={{
          'aria-label': 'Next Page',
        }}
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
