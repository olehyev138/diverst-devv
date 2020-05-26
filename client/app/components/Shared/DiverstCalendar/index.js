import React, { memo, useEffect, useRef, useState } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import { withStyles, withTheme } from '@material-ui/core/styles';
import { CircularProgress, Grid, Card, CardContent, Box, CardActions } from '@material-ui/core';
import FullCalendar from '@fullcalendar/react';
import dayGridPlugin from '@fullcalendar/daygrid';
import timeGridPlugin from '@fullcalendar/timegrid';
import listPlugin from '@fullcalendar/list';
import DiverstGroupLegend from 'components/Shared/DiverstCalendar/DiverstGroupLegend';

import 'stylesheets/main.scss';
import { Formik, Form } from 'formik';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Calendar/messages';
import GroupSelector from 'components/Shared/GroupSelector';
import DiverstSubmit from 'components/Shared/DiverstSubmit';
import { mapFields } from 'utils/formHelpers';
import { toNumber } from 'utils/floatRound';
import Dialog from '@material-ui/core/Dialog';
import DialogContent from '@material-ui/core/DialogContent';
import EventLite from 'components/Event/EventLite';

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

export function DiverstCalendar({ events, calendarEvents, isLoading, classes, ...rest }) {
  const calendarRef = React.createRef();
  const [eventId, setEvent] = useState(null);

  const clickEvent = (info) => {
    const { event } = info;
    // const extra = event.extendedProps;
    setEvent(toNumber(event.id));
  };

  const dialog = (
    <Dialog
      open={!!eventId}
      onClose={() => setEvent(null)}
    >
      <DialogContent>
        <EventLite
          event={events.find(event => event.id === eventId)}
          isCommiting={rest.isCommitting}
          joinEventBegin={rest.joinEventBegin}
          leaveEventBegin={rest.leaveEventBegin}
        />
      </DialogContent>
    </Dialog>
  );

  const groupFilter = (
    <Formik
      initialValues={{
        group_ids: ''
      }}
      enableReinitialize
      onSubmit={(values, actions) => {
        if (rest.groupFilterCallback)
          rest.groupFilterCallback(mapFields(values, ['group_ids']));
      }}
    >
      {formikProps => (
        <Form>
          <Card>
            <CardContent>
              <GroupSelector
                groupField='group_ids'
                label={<DiverstFormattedMessage {...messages.groups} />}
                isMulti
                inputCallback={(props, searchKey = '') => searchKey}
                {...formikProps}
              />
            </CardContent>
            <CardActions>
              <DiverstSubmit>
                <DiverstFormattedMessage {...messages.filter} />
              </DiverstSubmit>
            </CardActions>
          </Card>
        </Form>
      )}
    </Formik>
  );

  return (
    <React.Fragment>
      {dialog}
      {rest.groupLegend && (
        <React.Fragment>
          {groupFilter}
          <Box mb={1} />
        </React.Fragment>
      )}
      {rest.groupLegend && <DiverstGroupLegend />}
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
          events={calendarEvents}
          eventClick={clickEvent}
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
  groupLegend: PropTypes.bool,
  groupFilter: PropTypes.bool,
  groupFilterCallback: PropTypes.func,
  events: PropTypes.array,
  calendarEvents: PropTypes.arrayOf(PropTypes.shape({
    id: PropTypes.number,
    groupId: PropTypes.number,
    start: PropTypes.string,
    end: PropTypes.string,
    title: PropTypes.string,
    color: PropTypes.string,
  })),
  isCommitting: PropTypes.bool,
  joinEventBegin: PropTypes.func,
  leaveEventBegin: PropTypes.func,
};

export default compose(
  memo,
  withStyles(styles),
  withTheme,
)(DiverstCalendar);
