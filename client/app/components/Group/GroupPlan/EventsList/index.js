import React, { memo } from 'react';

import { compose } from 'redux';
import PropTypes from 'prop-types';
import dig from 'object-dig';

import {
  Typography, Card, CardContent, Divider, Link, CardActionArea, Box, Grid, Button, CardActions,
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';
import AddIcon from '@material-ui/icons/Add';
import EditIcon from '@material-ui/icons/Edit';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import messages from 'containers/Group/Outcome/messages';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';

import DiverstLoader from 'components/Shared/DiverstLoader';
import DiverstPagination from 'components/Shared/DiverstPagination';

import EventListItem from 'components/Group/GroupPlan/EventListItem';
import Permission from 'components/Shared/DiverstPermission';
import { permission } from 'utils/permissionsHelpers';
import Conditional from 'components/Compositions/Conditional';
import { ROUTES } from 'containers/Shared/Routes/constants';
import permissionMessages from 'containers/Shared/Permissions/messages';

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
  floatRight: {
    float: 'right',
  },
  floatSpacer: {
    display: 'flex',
    width: '100%',
    marginBottom: 0,
  },
});

export function EventsList(props) {
  const { classes } = props;
  const outcomes = dig(props, 'outcomes');

  return (
    <React.Fragment>
      <Permission show={permission(props.currentGroup, 'update?')}>
        <Button
          className={classes.floatRight}
          variant='contained'
          to={props.links.outcomeIndex}
          color='primary'
          size='medium'
          component={WrappedNavLink}
          startIcon={<EditIcon />}
        >
          <DiverstFormattedMessage {...messages.editStructure} />
        </Button>
        <Box className={classes.floatSpacer} />
      </Permission>
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
                      <Permission show={permission(props.currentGroup, 'events_create?')}>
                        <Button
                          variant='contained'
                          to={{ pathname: props.links.eventNew,
                            state: { pillar: { value: pillar.id, label: pillar.name } } }}
                          color='default'
                          size='medium'
                          component={WrappedNavLink}
                          startIcon={<AddIcon />}
                        >
                          <DiverstFormattedMessage {...messages.pillars.events.new} />
                        </Button>
                      </Permission>
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
                {pillar.initiatives && pillar.initiatives.length <= 0 && (
                  <React.Fragment>
                    <Divider />
                    <Box p={2}>
                      <Typography variant='h6' align='center' color='textSecondary'>
                        <DiverstFormattedMessage {...messages.pillars.events.empty} />
                      </Typography>
                    </Box>
                  </React.Fragment>
                )}
              </Card>
            ))}
            {outcome.pillars && outcome.pillars.length <= 0 && (
              <React.Fragment>
                <Box p={2} pb={5}>
                  <Typography variant='h6' align='center' color='textSecondary'>
                    <DiverstFormattedMessage {...messages.pillars.empty} />
                  </Typography>
                </Box>
              </React.Fragment>
            )}
          </React.Fragment>
        ))}
        {outcomes && outcomes.length <= 0 && (
          <React.Fragment>
            <Box mt={3} />
            <Typography variant='h6' align='center' color='textSecondary'>
              <DiverstFormattedMessage {...messages.empty} />
            </Typography>
          </React.Fragment>
        )}
      </DiverstLoader>
      {outcomes && outcomes.length > 0 && (
        <DiverstPagination
          isLoading={props.isLoading}
          rowsPerPage={props.params.count}
          rowsPerPageOptions={props.rowsPerPageOptions}
          count={props.outcomesTotal}
          handlePagination={props.handlePagination}
        />
      )}
    </React.Fragment>
  );
}

EventsList.propTypes = {
  classes: PropTypes.object,
  currentGroup: PropTypes.object,
  outcomes: PropTypes.array,
  outcomesTotal: PropTypes.number,
  isLoading: PropTypes.bool,
  handlePagination: PropTypes.func,
  params: PropTypes.object,
  rowsPerPageOptions: PropTypes.array,
  links: PropTypes.shape({
    outcomeIndex: PropTypes.string,
    eventNew: PropTypes.string,
    eventManage: PropTypes.func,
  })
};

export default compose(
  memo,
  withStyles(styles),
)(Conditional(
  EventsList,
  ['currentGroup.permissions.events_manage?'],
  (props, params) => ROUTES.group.plan.index.path(params.group_id),
  permissionMessages.group.groupPlan.eventList
));
