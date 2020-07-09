import React, { memo, useState } from 'react';

import { compose } from 'redux';
import PropTypes from 'prop-types';
import dig from 'object-dig';

import {
  Paper, Typography, Grid, Button, Box
} from '@material-ui/core/index';
import { withStyles } from '@material-ui/core/styles';
import AddIcon from '@material-ui/icons/Add';
import RemoveIcon from '@material-ui/icons/Remove';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import messages from 'containers/Event/messages';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';

import { formatDateTimeString, DateTime } from 'utils/dateTimeHelpers';

import DiverstImg from 'components/Shared/DiverstImg';
import { injectIntl, intlShape } from 'react-intl';

import { ROUTES } from 'containers/Shared/Routes/constants';
import Permission from 'components/Shared/DiverstPermission';
import { permission } from 'utils/permissionsHelpers';
import DiverstHTMLEmbedder from 'components/Shared/DiverstHTMLEmbedder';

const styles = theme => ({
  padding: {
    padding: theme.spacing(3, 2),
  },
  title: {
    textAlign: 'center',
    fontWeight: 'bold',
    paddingBottom: theme.spacing(3),
  },
  dataHeaders: {
    paddingBottom: theme.spacing(1),
  },
  data: {
    '&:not(:last-of-type)': { // Prevent last data item from adding bottom padding
      paddingBottom: theme.spacing(3),
    },
  },
  buttons: {
    marginLeft: 10,
    marginRight: 10,
    marginBottom: 20,
    float: 'right',
  },
  deleteButton: {
    backgroundColor: theme.palette.error.main,
  },
});

export function EventLite(props) {
  const { classes, intl } = props;
  const event = dig(props, 'event');

  return event ? (
    <React.Fragment>
      <Grid container spacing={1}>
        <Grid item>
          <Typography color='primary' variant='h5' component='h2' className={classes.title}>
            {event.name}
          </Typography>
        </Grid>
        <Grid item sm>
          {event.is_attending ? (
            <Button
              variant='contained'
              size='small'
              color='secondary'
              className={classes.buttons}
              onClick={() => {
                props.leaveEventBegin({
                  initiative_id: props.event.id,
                });
              }}
              startIcon={<RemoveIcon />}
            >
              <DiverstFormattedMessage {...messages.leave} />
            </Button>
          ) : (
            <Permission show={permission(props.event, 'join_event?')}>
              <Button
                variant='contained'
                size='small'
                color='primary'
                className={classes.buttons}
                onClick={() => {
                  props.joinEventBegin({
                    initiative_id: props.event.id,
                  });
                }}
                startIcon={<AddIcon />}
              >
                <DiverstFormattedMessage {...messages.join} />
              </Button>
            </Permission>
          )}
          <Button
            variant='contained'
            size='small'
            color='primary'
            component={WrappedNavLink}
            className={classes.buttons}
            to={ROUTES.group.events.show.path(event.group.id, event.id)}
          >
            <DiverstFormattedMessage {...messages.view} />
          </Button>
        </Grid>
      </Grid>
      <Paper className={classes.padding}>
        <Grid container spacing={2}>
          <Grid item xs>
            {event.picture_data && (
              <DiverstImg
                data={event.picture_data}
                maxWidth='100%'
                maxHeight='240px'
              />
            )}
            <Box mb={3} />
            {event.description && (
              <React.Fragment>
                <Typography className={classes.dataHeaders}>
                  <DiverstFormattedMessage {...messages.inputs.description} />
                </Typography>
                <DiverstHTMLEmbedder
                  html={event.description}
                  gridProps={{
                    alignItems: 'flex-start',
                  }}
                />
              </React.Fragment>
            )}
            <Typography className={classes.dataHeaders}>
              <DiverstFormattedMessage {...messages.show.dateAndTime} />
            </Typography>
            <Typography color='primary' className={classes.data}>
              {formatDateTimeString(event.start, DateTime.DATETIME_FULL)}
              <Typography display='inline' color='textSecondary'>
                    &nbsp;
                <DiverstFormattedMessage {...messages.show.until} />
                    &nbsp;
              </Typography>
              {formatDateTimeString(event.end, DateTime.DATETIME_FULL)}
            </Typography>
            {event.participating_groups.length > 0 && (
              <React.Fragment>
                <Typography className={classes.dataHeaders}>
                  <DiverstFormattedMessage {...messages.inputs.participating_groups} />
                </Typography>
                {event.participating_groups.map((group, i) => (
                  <Typography color='textSecondary' key={group.id}>
                    {group.name}
                  </Typography>
                ))}
              </React.Fragment>
            )}
          </Grid>
          <Grid item xs={3}>
            {event.location && (
              <React.Fragment>
                <Typography className={classes.dataHeaders}>
                  <DiverstFormattedMessage {...messages.inputs.location} />
                </Typography>
                <Typography color='textSecondary' className={classes.data}>
                  {event.location}
                </Typography>
              </React.Fragment>
            )}
            <Typography className={classes.dataHeaders}>
              <DiverstFormattedMessage {...messages.inputs.attendee} />
            </Typography>
            <Typography color='textSecondary' className={classes.data}>
              {event.total_attendees}
            </Typography>
          </Grid>
        </Grid>
      </Paper>
    </React.Fragment>
  ) : null;
}

EventLite.propTypes = {
  intl: intlShape.isRequired,
  deleteEventBegin: PropTypes.func,
  archiveEventBegin: PropTypes.func,
  joinEventBegin: PropTypes.func,
  leaveEventBegin: PropTypes.func,
  classes: PropTypes.object,
  event: PropTypes.object,
  currentGroup: PropTypes.object,
  currentUserId: PropTypes.number,
  isFormLoading: PropTypes.bool,
  links: PropTypes.shape({
    eventEdit: PropTypes.string,
  }),
  createEventCommentBegin: PropTypes.func,
  deleteEventCommentBegin: PropTypes.func,
  export: PropTypes.func,
};

export default compose(
  memo,
  injectIntl,
  withStyles(styles)
)(EventLite);
