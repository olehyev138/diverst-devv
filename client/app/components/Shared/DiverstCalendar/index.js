import React, { memo, useEffect, useState } from 'react';
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
import ReactTooltip from 'react-tooltip';

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

  return (
    <React.Fragment>
      {/* {legend} */}
      <ReactTooltip />
      <div className={classes.wrapper}>
        <FullCalendar
          ref={calendarRef}
          initialView='dayGridMonth'
          plugins={[dayGridPlugin, timeGridPlugin, listPlugin]}
          contentHeight={600}
          headerToolbar={{
            left: 'prev,next today',
            center: 'title',
            right: 'dayGridMonth,timeGridWeek,listWeek'
          }}
          events={events}
          eventDisplay='block'
          dayMaxEvents={5}
          dayMaxEventRows={5}
          eventDidMount={(info) => {
            const { event } = info;
            const xProps = event.extendedProps;

            info.el.setAttribute('data-tip',
              `${xProps.group.name}${xProps.description.length > 0 ? `<br>${xProps.description}` : ''}`);
            // eslint-disable-next-line func-names
            info.el.setAttribute('data-place', (function () {
              switch (calendarRef.current.getApi().view.type) {
                case 'dayGridMonth':
                  return 'top';
                case 'timeGridWeek':
                  return 'left';
                case 'listWeek':
                  return 'right';
                default:
                  return 'top';
              }
            }()));
            info.el.setAttribute('data-effect', 'solid');
            info.el.setAttribute('data-delay-show', '200');
            info.el.setAttribute('data-multiline', 'true');
            ReactTooltip.rebuild();
          }}
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
