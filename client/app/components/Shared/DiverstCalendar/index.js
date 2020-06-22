import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import { withStyles, withTheme } from '@material-ui/core/styles';
import { Box, Card, CircularProgress, Divider, Grid, Typography } from '@material-ui/core';
import FullCalendar from '@fullcalendar/react';
import dayGridPlugin from '@fullcalendar/daygrid';
import timeGridPlugin from '@fullcalendar/timegrid';
import listPlugin from '@fullcalendar/list';
import CheckBoxIcon from '@material-ui/icons/CheckBox';

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
  legend: {
    float: 'right',
    backgroundColor: theme.palette.primary.main,
    marginLeft: 5,
  },
});

export function DiverstCalendar({ events, isLoading, classes, ...rest }) {
  const calendarRef = React.createRef();

  const legend = (
    <Grid container>
      <Grid item xs={12}>
        <Card className={classes.legend}>
          <Box mb={1} mt={1} ml={1} mr={1}>
            <Typography variant='h6'>
              Legend
            </Typography>
            <Divider />
            <Typography style={{ color: 'black' }}>
              Participating
            </Typography>
            <Typography style={{ color: 'white' }}>
              Not Participating
            </Typography>
          </Box>
        </Card>
      </Grid>
    </Grid>
  );

  const getMethods = obj => Object.getOwnPropertyNames(obj).filter(item => typeof obj[item] === 'function');
  const getProperties = obj => Object.getOwnPropertyNames(obj).filter(item => typeof obj[item] !== 'function');

  return (
    <React.Fragment>
      {/* {legend} */}
      <div className={classes.wrapper}>
        <FullCalendar
          ref={calendarRef}
          defaultView='dayGridMonth'
          plugins={[dayGridPlugin, timeGridPlugin, listPlugin]}
          contentHeight={600}
          headerToolbar={{
            left: 'prev,next today',
            center: 'title',
            right: 'dayGridMonth,timeGridWeek,listWeek'
          }}
          events={events}
          dayMaxEvents={5}
          dayMaxEventRows={5}
          // eventContent={(info) => {
          //   console.log(info);
          //   return (
          //     <React.Fragment>
          //       <div className='fc-event-time'>
          //         {info.timeText}
          //       </div>
          //       <div className='fc-event-title-frame'>
          //         {info.event.title}
          //       </div>
          //     </React.Fragment>
          //   );
          // }}
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
    </React.Fragment>
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
