import React, { memo } from 'react';

import { compose } from 'redux';
import PropTypes from 'prop-types';
import dig from 'object-dig';

import {
  Paper, Typography, Grid, Button, Box
} from '@material-ui/core/index';
import { withStyles } from '@material-ui/core/styles';
import EditIcon from '@material-ui/icons/Edit';
import DeleteIcon from '@material-ui/icons/DeleteOutline';
import ArchiveIcon from '@material-ui/icons/Archive';
import AddIcon from '@material-ui/icons/Add';

import classNames from 'classnames';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import messages from 'containers/Event/messages';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';

import DiverstShowLoader from 'components/Shared/DiverstShowLoader';

import { formatDateTimeString, DateTime } from 'utils/dateTimeHelpers';

import DiverstImg from 'components/Shared/DiverstImg';
import { injectIntl, intlShape } from 'react-intl';

import EventComment from 'components/Event/EventComment';
import EventCommentForm from 'components/Event/EventCommentForm';

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
    marginLeft: 20,
    float: 'right',
  },
  deleteButton: {
    backgroundColor: theme.palette.error.main,
  },
});

export function Event(props) {
  const { classes, intl } = props;
  const event = dig(props, 'event');
  return (
    <DiverstShowLoader isLoading={props.isFormLoading} isError={!props.isFormLoading && !event}>
      {event && (
        <React.Fragment>
          <Grid container spacing={1}>
            <Grid item>
              <Typography color='primary' variant='h5' component='h2' className={classes.title}>
                {event.name}
              </Typography>
            </Grid>
            <Grid item sm>
              <Button
                variant='contained'
                size='large'
                color='primary'
                className={classNames(classes.buttons, classes.deleteButton)}
                startIcon={<DeleteIcon />}
                onClick={() => {
                  /* eslint-disable-next-line no-alert, no-restricted-globals */
                  if (confirm(intl.formatMessage(messages.delete_confirm)))
                    props.deleteEventBegin({
                      id: event.id,
                      group_id: event.owner_group_id
                    });
                }}
              >
                <DiverstFormattedMessage {...messages.delete} />
              </Button>
              <Button
                component={WrappedNavLink}
                to={props.links.eventEdit}
                variant='contained'
                size='large'
                color='primary'
                className={classes.buttons}
                startIcon={<EditIcon />}
              >
                <DiverstFormattedMessage {...messages.edit} />
              </Button>
              <Button
                variant='contained'
                size='large'
                color='primary'
                className={classes.buttons}
                onClick={() => {
                  props.archiveEventBegin({
                    id: props.event.id,
                    group_id: event.owner_group_id
                  });
                }}
                startIcon={<ArchiveIcon />}
              >
                <DiverstFormattedMessage {...messages.archive} />
              </Button>
              <Button
                variant='contained'
                size='large'
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
            </Grid>
          </Grid>
          <Paper className={classes.padding}>
            <Grid container spacing={2}>
              <Grid item xs>
                <Typography className={classes.dataHeaders}>
                  <DiverstFormattedMessage {...messages.show.dateAndTime} />
                </Typography>
                <Typography variant='overline'>From</Typography>
                <Typography color='textSecondary'>{formatDateTimeString(event.start, DateTime.DATETIME_FULL)}</Typography>
                <Typography variant='overline'>To</Typography>
                <Typography color='textSecondary' className={classes.data}>{formatDateTimeString(event.end, DateTime.DATETIME_FULL)}</Typography>

                {event.description && (
                  <React.Fragment>
                    <Typography className={classes.dataHeaders}>
                      <DiverstFormattedMessage {...messages.inputs.description} />
                    </Typography>
                    <Typography color='textSecondary' className={classes.data}>
                      {event.description}
                    </Typography>
                  </React.Fragment>
                )}
              </Grid>
              <Grid item>
                <DiverstImg
                  data={event.picture_data}
                />
              </Grid>
            </Grid>
          </Paper>
          <Box mb={4} />
          <EventCommentForm
            currentUserId={props.currentUserId}
            event={props.event}
            commentAction={props.createEventCommentBegin}
          />
          <Box mb={4} />
          <Typography variant='h6'>
            {event.total_comments}
            &ensp;
            <DiverstFormattedMessage {...messages.comment.total_comments} />
          </Typography>
          { /* eslint-disable-next-line arrow-body-style */}
          {dig(event, 'comments').sort((a, b) => a.created_at < b.created_at) && event.comments.map((comment, i) => {
            return (
              <EventComment
                key={comment.id}
                comment={comment}
                deleteEventCommentBegin={props.deleteEventCommentBegin}
                event={props.event}
                currentUserId={props.currentUserId}
              />
            );
          })}
        </React.Fragment>
      )}
    </DiverstShowLoader>
  );
}

Event.propTypes = {
  intl: intlShape,
  deleteEventBegin: PropTypes.func,
  archiveEventBegin: PropTypes.func,
  joinEventBegin: PropTypes.func,
  classes: PropTypes.object,
  event: PropTypes.object,
  currentUserId: PropTypes.number,
  isFormLoading: PropTypes.bool,
  links: PropTypes.shape({
    eventEdit: PropTypes.string,
  }),
  createEventCommentBegin: PropTypes.func,
  deleteEventCommentBegin: PropTypes.func,
};

export default compose(
  memo,
  injectIntl,
  withStyles(styles)
)(Event);
