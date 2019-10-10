import React, { memo } from 'react';

import { compose } from 'redux/';
import PropTypes from 'prop-types';
import dig from 'object-dig';

import {
  Paper, Typography, Grid, Button
} from '@material-ui/core/index';
import { withStyles } from '@material-ui/core/styles';

import classNames from 'classnames';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import messages from 'containers/Event/messages';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';

import { formatDateTimeString, DateTime } from 'utils/dateTimeHelpers';

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
  /* Render an Event */

  const { classes } = props;
  const event = dig(props, 'event');

  return (
    (event) ? (
      <React.Fragment>
        <Grid container spacing={1}>
          <Grid item>
            <Typography color='primary' variant='h5' component='h2' className={classes.title}>
              {event.name}
            </Typography>
          </Grid>
          <Grid item sm>
            <Button
              component={WrappedNavLink}
              to={props.links.eventEdit}
              variant='contained'
              size='large'
              color='primary'
              className={classes.buttons}
            >
              <DiverstFormattedMessage {...messages.edit} />
            </Button>
            <Button
              variant='contained'
              size='large'
              color='primary'
              className={classNames(classes.buttons, classes.deleteButton)}
              onClick={() => {
                /* eslint-disable-next-line no-alert, no-restricted-globals */
                if (confirm('Delete event?'))
                  props.deleteEventBegin({ id: event.id, group_id: event.owner_group_id });
              }}
            >
              <DiverstFormattedMessage {...messages.delete} />
            </Button>
          </Grid>
        </Grid>
        <Paper className={classes.padding}>
          <Typography className={classes.dataHeaders}>
            <DiverstFormattedMessage {...messages.show.dateAndTime} />
          </Typography>
          <Typography variant='overline'>From</Typography>
          <Typography color='textSecondary'>{formatDateTimeString(event.start, DateTime.DATETIME_FULL)}</Typography>
          <Typography variant='overline'>To</Typography>
          <Typography color='textSecondary' className={classes.data}>{formatDateTimeString(event.end, DateTime.DATETIME_FULL)}</Typography>

          <Typography className={classes.dataHeaders}>
            <DiverstFormattedMessage {...messages.form.description} />
          </Typography>
          <Typography color='textSecondary' className={classes.data}>
            {event.description}
          </Typography>
        </Paper>
      </React.Fragment>
    ) : <React.Fragment />
  );
}

Event.propTypes = {
  deleteEventBegin: PropTypes.func,
  classes: PropTypes.object,
  event: PropTypes.object,
  currentUserId: PropTypes.number,
  links: PropTypes.shape({
    eventEdit: PropTypes.string,
  })
};

export default compose(
  memo,
  withStyles(styles)
)(Event);
