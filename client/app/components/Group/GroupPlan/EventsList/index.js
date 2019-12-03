import React, { memo } from 'react';

import { compose } from 'redux';
import PropTypes from 'prop-types';
import dig from 'object-dig';

import {
  Typography, Card, CardContent, Divider, Link, CardActionArea, Box, Grid, Button, CardActions,
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';
import AddIcon from '@material-ui/icons/Add';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import messages from 'containers/Group/Outcome/messages';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';

import DiverstLoader from 'components/Shared/DiverstLoader';
import DiverstPagination from 'components/Shared/DiverstPagination';

import EventListItem from 'components/Group/GroupPlan/EventListItem';

const styles = theme => ({
  title: {
    fontWeight: 'bold',
    paddingBottom: theme.spacing(3),
  },
  card: {
    marginBottom: 32,
  },
  eventLink: {
    textDecoration: 'none !important',
  },
  eventListItemSpacer: {
    backgroundColor: theme.palette.primary.main50,
    width: 10,
  },
  divider: {
    height: 2,
  },
});

export function EventsList(props) {
  const { classes } = props;
  const outcomes = dig(props, 'outcomes');

  return (
    <React.Fragment>
      <DiverstLoader isLoading={props.isLoading}>
        {outcomes && outcomes.length > 0 && outcomes.map(outcome => (
          <React.Fragment key={outcome.id}>
            <Typography color='primary' variant='h5' component='h2' className={classes.title}>
              {outcome.name}
            </Typography>
            {outcome.pillars && outcome.pillars.length > 0 && outcome.pillars.map(pillar => (
              <Card key={pillar.id} className={classes.card}>
                <CardContent>
                  <Grid container spacing={2} alignItems='center'>
                    <Grid item xs>
                      <Typography variant='h6'>
                        {pillar.name}
                      </Typography>
                    </Grid>
                    <Grid item>
                      <Button
                        variant='contained'
                        to={props.links.eventNew}
                        color='primary'
                        size='large'
                        component={WrappedNavLink}
                        startIcon={<AddIcon />}
                      >
                        <DiverstFormattedMessage {...messages.pillars.events.new} />
                      </Button>
                    </Grid>
                  </Grid>
                </CardContent>
                {pillar.initiatives && pillar.initiatives.length > 0 && pillar.initiatives.map(initiative => (
                  <React.Fragment key={initiative.id}>
                    <Divider className={classes.divider} />
                    <Link
                      className={classes.eventLink}
                      component={WrappedNavLink}
                      to={props.links.eventManage(initiative.id)}
                    >
                      <CardActionArea>
                        <Grid container>
                          <Grid item className={classes.eventListItemSpacer} />
                          <Grid item xs>
                            <CardContent>
                              <EventListItem item={initiative} />
                              <Box mb={1} />
                            </CardContent>
                          </Grid>
                        </Grid>
                      </CardActionArea>
                    </Link>
                  </React.Fragment>
                ))}
              </Card>
            ))}
          </React.Fragment>
        ))}
      </DiverstLoader>
      {outcomes && outcomes.length > 0 && (
        <DiverstPagination
          isLoading={props.isLoading}
          rowsPerPage={props.params.count}
          count={props.outcomesTotal}
          handlePagination={props.handlePagination}
        />
      )}
    </React.Fragment>
  );
}

EventsList.propTypes = {
  classes: PropTypes.object,
  outcomes: PropTypes.array,
  outcomesTotal: PropTypes.number,
  isLoading: PropTypes.bool,
  handlePagination: PropTypes.func,
  params: PropTypes.object,
  links: PropTypes.shape({
    outcomeIndex: PropTypes.string,
    eventNew: PropTypes.string,
    eventManage: PropTypes.func,
  })
};

export default compose(
  memo,
  withStyles(styles),
)(EventsList);
