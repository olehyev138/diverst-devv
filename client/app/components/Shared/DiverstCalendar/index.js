import React, { memo, useEffect, useState } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import { withStyles, withTheme } from '@material-ui/core/styles';
import { Box, Card, CircularProgress, Divider, Grid, Typography, CardActions, CardContent } from '@material-ui/core';
import FullCalendar from '@fullcalendar/react';
import dayGridPlugin from '@fullcalendar/daygrid';
import timeGridPlugin from '@fullcalendar/timegrid';
import listPlugin from '@fullcalendar/list';
import CheckBoxIcon from '@material-ui/icons/CheckBox';
import { formatDate } from '@fullcalendar/core';
import DiverstGroupLegend from 'components/Shared/DiverstCalendar/DiverstGroupLegend';
import ReactTooltip from 'react-tooltip';
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
import SegmentSelector from 'components/Shared/SegmentSelector';
import dig from 'object-dig';

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
        group_ids: [],
        segment_ids: [],
      }}
      enableReinitialize
      onSubmit={(values, actions) => {
        if (rest.groupFilterCallback)
          rest.groupFilterCallback(mapFields(values, ['group_ids', 'segment_ids']));
      }}
    >
      {formikProps => (
        <Form>
          <Card>
            <CardContent>
              <Grid container spacing={2}>
                <Grid item xs={12} md={6}>
                  <GroupSelector
                    groupField='group_ids'
                    label={<DiverstFormattedMessage {...messages.groups} />}
                    isMulti
                    inputCallback={(props, searchKey = '') => searchKey}
                    {...formikProps}
                  />
                </Grid>
                <Grid item xs={12} md={6}>
                  <SegmentSelector
                    segmentField='segment_ids'
                    label={<DiverstFormattedMessage {...messages.segments} />}
                    isMulti
                    {...formikProps}
                  />
                </Grid>
              </Grid>
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
      {dialog}
      {rest.groupLegend && (
        <React.Fragment>
          {groupFilter}
          <Box mb={1} />
        </React.Fragment>
      )}
      {rest.groupLegend && <DiverstGroupLegend />}
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
  calendarDateCallback: PropTypes.func,
};

DiverstCalendar.defaultProps = {
  events: []
};

export default compose(
  memo,
  withStyles(styles),
  withTheme,
)(DiverstCalendar);
