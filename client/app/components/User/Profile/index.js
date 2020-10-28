import React, { memo } from 'react';

import { compose } from 'redux/';
import PropTypes from 'prop-types';

import {
  Paper, Typography, Grid, Button, Divider, CardContent, Box, Avatar
} from '@material-ui/core/index';
import { withStyles } from '@material-ui/core/styles';

import EditIcon from '@material-ui/icons/Edit';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import messages from 'containers/User/messages';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import CustomFieldShow from 'components/Shared/Fields/FieldDisplays/Field/index';

import DiverstShowLoader from 'components/Shared/DiverstShowLoader';
import DiverstImg from 'components/Shared/DiverstImg';

import LocaleToggle from 'containers/Shared/LocaleToggle';
import Permission from 'components/Shared/DiverstPermission';
import { permission } from 'utils/permissionsHelpers';

const styles = theme => ({
  padding: {
    padding: theme.spacing(3, 2),
    margin: theme.spacing(1, 0),
  },
  title: {
    textAlign: 'center',
    fontWeight: 'bold',
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
  const user = props?.user;
  const fieldData = props?.fieldData;

  return (
    <DiverstShowLoader isLoading={props.isFormLoading} isError={!props.isFormLoading && !user}>
      {user && (
        <React.Fragment>
          <Box mb={2}>
            <Grid container spacing={1} alignItems='flex-end'>
              <Grid item>
                <Paper>
                  <CardContent>
                    <Grid container spacing={3} alignItems='center'>
                      <Grid item>
                        <Typography color='primary' variant='h5' component='h2' className={classes.title}>
                          {user.name}
                        </Typography>
                      </Grid>
                      <Grid item>
                        <LocaleToggle />
                      </Grid>
                    </Grid>
                  </CardContent>
                </Paper>
              </Grid>
              <Permission show={permission(user, 'update?')}>
                <Grid item sm>
                  <Button
                    component={WrappedNavLink}
                    to={props.links.userEdit(user.id)}
                    variant='contained'
                    size='large'
                    color='primary'
                    className={classes.buttons}
                    startIcon={<EditIcon />}
                  >
                    <DiverstFormattedMessage {...messages.edit} />
                  </Button>
                </Grid>
              </Permission>
            </Grid>
          </Box>
          <Paper>
            <CardContent>
              <Grid item>
                <Typography color='primary' variant='h6' component='h2' className={classes.dataHeaders}>
                  {<DiverstFormattedMessage {...messages.avatar} />}
                </Typography>
                <Avatar>
                  { user.avatar ? (
                    <DiverstImg
                      data={user.avatar_data}
                      contentType={user.avatar_content_type}
                      maxWidth='100%'
                      maxHeight='240px'
                    />
                  ) : (
                    user.first_name[0]
                  )}
                </Avatar>
              </Grid>
            </CardContent>
            <Divider />
            <CardContent>
              <Grid item>
                <Typography color='primary' variant='h6' component='h2' className={classes.dataHeaders}>
                  {<DiverstFormattedMessage {...messages.email} />}
                </Typography>
                <Typography color='secondary' component='h2' className={classes.data}>
                  {user.email}
                </Typography>
              </Grid>
            </CardContent>
            <Divider />
            <CardContent>
              <Grid item>
                <Typography color='primary' variant='h6' component='h2' className={classes.dataHeaders}>
                  {<DiverstFormattedMessage {...messages.biography} />}
                </Typography>
                {(user.biography || 'None').split('\n').map((text, i) => (
                  // eslint-disable-next-line react/no-array-index-key
                  <Typography color='secondary' component='h2' key={i}>
                    {text}
                  </Typography>
                ))}
              </Grid>
            </CardContent>
            <Divider />
            <CardContent>
              <Grid item>
                <Typography color='primary' variant='h6' component='h2' className={classes.dataHeaders}>
                  {<DiverstFormattedMessage {...messages.time_zone} />}
                </Typography>
                <Typography color='secondary' component='h2' className={classes.data}>
                  {user.time_zone || 'UTC'}
                </Typography>
              </Grid>
            </CardContent>
            <Divider />
            {fieldData && fieldData.filter(fd => !fd.field.private).map((fieldDatum, i) => (
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
  currentUserId: PropTypes.number,
  isFormLoading: PropTypes.bool,
  links: PropTypes.shape({
    userEdit: PropTypes.func,
  })
};

export default compose(
  memo,
  withStyles(styles)
)(Profile);
