import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import { withStyles, withTheme } from '@material-ui/core/styles';
import { Grid } from '@material-ui/core';
import FullCalendar from '@fullcalendar/react';
import dayGridPlugin from '@fullcalendar/daygrid';

const styles = theme => ({});

export function DiverstCalendar({ events }) {
  return (
    <FullCalendar
      defaultView='dayGridMonth'
      plugins={[dayGridPlugin]}
      events={events}
    />
  );
}

DiverstCalendar.propTypes = {
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
