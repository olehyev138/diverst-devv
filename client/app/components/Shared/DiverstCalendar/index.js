import React, { memo, useEffect, useRef, useState } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import { withStyles, withTheme } from '@material-ui/core/styles';
import { CircularProgress, Grid } from '@material-ui/core';
import FullCalendar from '@fullcalendar/react';
import dayGridPlugin from '@fullcalendar/daygrid';
import timeGridPlugin from '@fullcalendar/timegrid';
import listPlugin from '@fullcalendar/list';

import 'stylesheets/main.scss';

const styles = theme => ({
  wrapper: {
    margin: theme.spacing(1),
    position: 'relative',
  },
  buttonProgress: {
    position: 'absolute',
    top: '50%',
    left: '50%',
    marginTop: -12,
    marginLeft: -12,
  },
});

export function DiverstCalendar({ events, isLoading, classes, ...rest }) {
  const calendarRef = React.createRef();

  return (
    <div className={classes.wrapper}>
      <FullCalendar
        ref={calendarRef}
        defaultView='dayGridMonth'
        plugins={[dayGridPlugin, timeGridPlugin, listPlugin]}
        header={{
          left: 'prev,next today',
          center: 'title',
          right: 'dayGridMonth,timeGridWeek,listWeek'
        }}
        events={events}
        {...rest}
      />
      {isLoading && (
        <Grid container justify='center' alignContent='center'>
          <Grid item>
            <CircularProgress size={80} thickness={1.5} className={classes.buttonProgress} />
          </Grid>
        </Grid>
      )}
    </div>
  );
}

DiverstCalendar.propTypes = {
  classes: PropTypes.object,
  isLoading: PropTypes.bool,
  events: PropTypes.arrayOf(PropTypes.shape({
    id: PropTypes.number,
    groupId: PropTypes.number,
    start: PropTypes.string,
    end: PropTypes.string,
    title: PropTypes.string,
    color: PropTypes.string,
  })),
};

export default compose(
  memo,
  withStyles(styles),
  withTheme,
)(DiverstCalendar);
