import React, { memo } from 'react';

import { compose } from 'redux/';
import PropTypes from 'prop-types';
import dig from 'object-dig';

import { Card, CardContent, Grid } from '@material-ui/core/index';
import { withStyles } from '@material-ui/core/styles';

const styles = theme => ({});

export function Event(props) {
  /* Render an Event */

  const { classes } = props;
  const eventItem = dig(props, 'event');
  const event = dig(event, 'group_message');

  return (
    (event) ? (
      <React.Fragment>
        <Grid container spacing={3}>
          <Grid item>
            <Card>
              <CardContent>
                <p>{event.name}</p>
              </CardContent>
            </Card>
          </Grid>
        </Grid>
      </React.Fragment>
    ) : <React.Fragment />
  );
}

Event.propTypes = {
  classes: PropTypes.object,
  event: PropTypes.object,
  currentUserId: PropTypes.number,
  links: PropTypes.shape({
    eventEdit: PropTypes.func
  })
};

export default compose(
  memo,
  withStyles(styles)
)(Event);
