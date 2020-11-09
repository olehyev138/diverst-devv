/**
 *
 * Region Members List Component
 *
 */

import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import {
  Button, Box, Grid, Typography, Card, CardContent, CardActions,
} from '@material-ui/core';

import { withStyles } from '@material-ui/core/styles';

import { injectIntl, intlShape } from 'react-intl';
import { Formik, Form } from 'formik';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import SegmentSelector from 'components/Shared/SegmentSelector';
import messages from 'containers/Region/messages';

import DiverstTable from 'components/Shared/DiverstTable';

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

  const handleOrderChange = (columnId, orderDir) => {
    props.handleOrdering({
      orderBy: (columnId === -1) ? 'id' : `${columns[columnId].query_field}`,
      orderDir: (columnId === -1) ? 'asc' : orderDir
    });
  };

  const columns = [
    {
      title: intl.formatMessage(messages.members.table.columns.givenName),
      field: 'first_name',
      query_field: 'first_name'
    },
    {
      title: intl.formatMessage(messages.members.table.columns.familyName),
      field: 'last_name',
      query_field: 'last_name'
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
  handleChangeTab: PropTypes.func.isRequired,
  segmentLabels: PropTypes.array,
  handleFilterChange: PropTypes.func.isRequired,
  currentRegion: PropTypes.object,
};

export default compose(
  memo,
  withStyles(styles),
  injectIntl,
)(RegionMembersList);
