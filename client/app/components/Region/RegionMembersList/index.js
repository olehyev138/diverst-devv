/**
 *
 * Region Members List Component
 *
 */

import React, { memo, useState } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import {
  Button, Box, MenuItem, Grid, Typography, Card, CardContent, CardActions, DialogContent,
  DialogActions, Dialog, FormGroup, FormControlLabel, Checkbox
} from '@material-ui/core';

import { withStyles } from '@material-ui/core/styles';

import { injectIntl, intlShape } from 'react-intl';
import { Field, Formik, Form } from 'formik';
import { DiverstDatePicker } from 'components/Shared/Pickers/DiverstDatePicker';
import { DateTime } from 'luxon';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import SegmentSelector from 'components/Shared/SegmentSelector';
import messages from 'containers/Region/messages';

import DiverstTable from 'components/Shared/DiverstTable';
import DiverstDropdownMenu from 'components/Shared/DiverstDropdownMenu';
import DiverstSubmit from 'components/Shared/DiverstSubmit';

const styles = theme => ({
  errorButton: {
    color: theme.palette.error.main,
  },
  actionButton: {
    marginRight: 12,
    marginBottom: 12,
  },
  submitButton: {
    marginLeft: 12,
    marginBottom: 12,
  },
  staticWidthButton: {
    width: '100%',
    marginLeft: 12,
    marginRight: 12,
  },
  menuItem: {
    width: '300',
  },
  floatRight: {
    float: 'right',
    marginBottom: 12,
  },
  floatLeft: {
    float: 'left',
    marginBottom: 12,
  },
  halfWidth: {
    width: '400',
  },
  dateTime: {
    width: '50%'
  },
  floatSpacer: {
    display: 'flex',
    width: '100%',
    marginBottom: 12,
  },
});

export function RegionMembersList(props) {
  const { classes, intl } = props;

  // MENU CODE
  const [anchor, setAnchor] = React.useState(null);

  const handleClick = (event) => {
    setAnchor(event.currentTarget);
  };

  const handleClose = (type) => {
    setAnchor(null);
    props.handleChangeTab(type);
  };

  const handleOrderChange = (columnId, orderDir) => {
    props.handleOrdering({
      orderBy: (columnId === -1) ? 'users.id' : `${columns[columnId].query_field}`,
      orderDir: (columnId === -1) ? 'asc' : orderDir
    });
  };

  const columns = [
    {
      title: intl.formatMessage(messages.members.table.columns.givenName),
      field: 'user.first_name',
      query_field: 'users.first_name'
    },
    {
      title: intl.formatMessage(messages.members.table.columns.familyName),
      field: 'user.last_name',
      query_field: 'users.last_name'
    },
    {
      title: intl.formatMessage(messages.members.table.columns.status),
      field: 'status',
      query_field: '(CASE WHEN users.active = false THEN 3 WHEN groups.pending_users AND NOT accepted_member THEN 2 ELSE 1 END)',
      sorting: true,
      lookup: {
        active: intl.formatMessage(messages.members.table.columns.status.active),
        inactive: intl.formatMessage(messages.members.table.columns.status.inactive),
        pending: intl.formatMessage(messages.members.table.columns.status.pending),
      }
    },
  ];

  return (
    <React.Fragment>
      <Grid container spacing={1} alignItems='flex-end'>
        <Grid item md={4} container alignItems='stretch'>
          <Card>
            <CardContent>
              <Grid container direction='column' spacing={3}>
                <Grid item>
                  <Grid
                    container
                    justify='space-between'
                    spacing={3}
                    alignContent='stretch'
                    alignItems='center'
                  >
                    <Grid item md='auto'>
                      <Typography align='left' variant='h6' component='h2' color='primary'>
                        <DiverstFormattedMessage {...messages.members.filter.changeScope} />
                      </Typography>
                    </Grid>
                    <Grid item md='auto'>
                      <Button
                        variant='contained'
                        color='secondary'
                        size='large'
                        onClick={handleClick}
                      >
                        <DiverstFormattedMessage {...messages.members.scopes[props.memberType]} />
                      </Button>
                    </Grid>
                  </Grid>
                </Grid>
                <Grid item>
                  <Grid
                    container
                    justify='space-between'
                    spacing={3}
                    alignContent='stretch'
                    alignItems='center'
                  >
                    <Grid item md='auto'>
                      <Typography align='left' variant='h6' component='h2' color='primary'>
                        <DiverstFormattedMessage {...messages.members.table.count} />
                      </Typography>
                    </Grid>
                    <Grid item md='auto'>
                      <Typography>
                        {props.memberTotal}
                      </Typography>
                    </Grid>
                  </Grid>
                </Grid>
              </Grid>
            </CardContent>
          </Card>
        </Grid>
        <Grid item md={8}>
          <Card>
            <Formik
              initialValues={{
                from: props.memberFrom,
                to: props.memberTo,
                segmentLabels: props.segmentLabels,
              }}
              enableReinitialize
              onSubmit={(values) => {
                values.segmentIds = (values.segmentLabels || []).map(i => i.value);
                props.handleFilterChange(values);
              }}
            >
              {formikProps => (
                <Form>
                  <CardContent>
                    <Grid container spacing={2}>
                      <Grid item xs={6}>
                        <Field
                          component={DiverstDatePicker}
                          keyboardMode
                          fullWidth
                          maxDate={formikProps.values.to ? formikProps.values.to : new Date()}
                          maxDateMessage={<DiverstFormattedMessage {...messages.members.filter.fromMax} />}
                          id='from'
                          name='from'
                          margin='normal'
                          isClearable
                          label={<DiverstFormattedMessage {...messages.members.filter.from} />}
                        />
                      </Grid>
                      <Grid item xs={6}>
                        <Field
                          component={DiverstDatePicker}
                          keyboardMode
                          fullWidth
                          minDate={formikProps.values.from ? formikProps.values.from : undefined}
                          maxDate={new Date()}
                          minDateMessage={<DiverstFormattedMessage {...messages.members.filter.toMin} />}
                          maxDateMessage={<DiverstFormattedMessage {...messages.members.filter.toMax} />}
                          id='to'
                          name='to'
                          margin='normal'
                          isClearable
                          label={<DiverstFormattedMessage {...messages.members.filter.to} />}
                        />
                      </Grid>
                    </Grid>
                    <SegmentSelector
                      segmentField='segmentLabels'
                      label={<DiverstFormattedMessage {...messages.members.filter.segments} />}
                      {...formikProps}
                    />
                  </CardContent>
                  <CardActions>
                    <Button
                      color='primary'
                      type='submit'
                      variant='contained'
                      className={classes.submitButton}
                    >
                      <DiverstFormattedMessage {...messages.members.filter.submit} />
                    </Button>
                  </CardActions>
                </Form>
              )}
            </Formik>
          </Card>
        </Grid>
      </Grid>
      <Box className={classes.floatSpacer} />
      <DiverstTable
        title={intl.formatMessage(messages.members.table.title)}
        handlePagination={props.handlePagination}
        handleSearching={props.handleSearching}
        isLoading={props.isLoading}
        onOrderChange={handleOrderChange}
        dataArray={props.memberList}
        dataTotal={props.memberTotal}
        columns={columns}
        rowsPerPage={props.params.count}
      />
      <DiverstDropdownMenu
        anchor={anchor}
        setAnchor={setAnchor}
      >
        <MenuItem
          onClick={() => handleClose('accepted_users')}
          className={classes.menuItem}
        >
          <DiverstFormattedMessage {...messages.members.scopes.accepted_users} />
        </MenuItem>
        <MenuItem
          onClick={() => handleClose('inactive')}
          className={classes.menuItem}
        >
          <DiverstFormattedMessage {...messages.members.scopes.inactive} />
        </MenuItem>
        <MenuItem
          onClick={() => handleClose('pending')}
          className={classes.menuItem}
        >
          <DiverstFormattedMessage {...messages.members.scopes.pending} />
        </MenuItem>
        <MenuItem
          onClick={() => handleClose('all')}
          className={classes.menuItem}
        >
          <DiverstFormattedMessage {...messages.members.scopes.all} />
        </MenuItem>
      </DiverstDropdownMenu>
    </React.Fragment>
  );
}

RegionMembersList.propTypes = {
  intl: intlShape.isRequired,
  classes: PropTypes.object,
  formGroupFamily: PropTypes.array,
  params: PropTypes.object,
  memberList: PropTypes.array,
  memberTotal: PropTypes.number,
  isLoading: PropTypes.bool,
  regionId: PropTypes.string,
  handlePagination: PropTypes.func,
  handleOrdering: PropTypes.func,
  handleSearching: PropTypes.func,

  memberType: PropTypes.string.isRequired,
  MemberTypes: PropTypes.array.isRequired,
  handleChangeTab: PropTypes.func.isRequired,

  memberFrom: PropTypes.instanceOf(DateTime),
  memberTo: PropTypes.instanceOf(DateTime),
  segmentLabels: PropTypes.array,
  handleFilterChange: PropTypes.func.isRequired,
  currentRegion: PropTypes.object,
};

export default compose(
  memo,
  withStyles(styles),
  injectIntl,
)(RegionMembersList);
