import React, { memo } from 'react';

import { compose } from 'redux/';
import PropTypes from 'prop-types';
import dig from 'object-dig';

import {
  Paper, Typography, Grid, Button, Divider, CardContent, Card
} from '@material-ui/core/index';
import { withStyles } from '@material-ui/core/styles';

import EditIcon from '@material-ui/icons/Edit';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import messages from 'containers/Shared/Update/messages';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import CustomFieldShow from 'components/Shared/Fields/FieldDisplays/Field/index';

import DiverstShowLoader from 'components/Shared/DiverstShowLoader';

const styles = theme => ({
  padding: {
    padding: theme.spacing(3, 2),
    margin: theme.spacing(1, 0),
  },
  title: {
    textAlign: 'left',
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
});

export function Profile(props) {
  const { classes } = props;
  const update = dig(props, 'update');
  const fieldData = dig(update, 'field_data');

  return (
    <DiverstShowLoader isLoading={props.isFetching} isError={!props.isFetching && !update}>
      {update && (
        <React.Fragment>
          <Grid container spacing={1}>
            <Grid item>
              <Typography color='primary' variant='h5' component='h2' className={classes.title}>
                {update.report_date}
              </Typography>
              <Typography color='secondary' variant='h5' component='h2' className={classes.title}>
                {update.comments}
              </Typography>
            </Grid>
            <Grid item sm>
              <Button
                component={WrappedNavLink}
                to={{
                  pathname: props.links.edit(update.id),
                  update
                }}
                variant='contained'
                size='large'
                color='primary'
                className={classes.buttons}
                startIcon={<EditIcon />}
              >
                <DiverstFormattedMessage {...messages.edit} />
              </Button>
            </Grid>
          </Grid>
          <Paper>
            {fieldData && fieldData.map((fieldDatum, i) => (
              <div key={fieldDatum.id}>
                <CardContent>
                  <Grid item>
                    <CustomFieldShow
                      fieldDatum={fieldDatum}
                      fieldDatumIndex={i}
                    />
                  </Grid>
                </CardContent>
                <Divider />
              </div>
            ))}
          </Paper>
        </React.Fragment>
      )}
    </DiverstShowLoader>
  );
}

Profile.propTypes = {
  deleteEventBegin: PropTypes.func,
  classes: PropTypes.object,
  event: PropTypes.object,
  currentUpdateId: PropTypes.number,
  isFetching: PropTypes.bool,
  links: PropTypes.shape({
    edit: PropTypes.func,
  })
};

export default compose(
  memo,
  withStyles(styles)
)(Profile);
