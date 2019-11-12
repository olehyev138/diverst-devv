/**
 *
 * Campaign Form Component
 *
 */

import React, {memo, useState} from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import {
  Button, Card, CardActions, CardContent, Divider, Grid, TextField
} from '@material-ui/core';
import Select from 'components/Shared/DiverstSelect';
import DiverstDateTimePicker from 'components/Shared/Pickers/DiverstDateTimePicker';
import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { Field, Formik, Form } from 'formik';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Group/GroupMembers/messages';
import DiverstSubmit from 'components/Shared/DiverstSubmit';

import { buildValues, mapFields } from 'utils/formHelpers';
import { DateTime } from 'luxon';

/* eslint-disable object-curly-newline */
export function CampaignFormInner({ handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, touched, ...props }) {
  const groupSelectAction = (searchKey = '') => {
    props.getGroupsBegin({
      count: 10, page: 0, order: 'asc',
      search: searchKey,
    });
  };

  return (
    <Card>
      <Form>
        <CardContent>
          <Field
            component={TextField}
            required
            onChange={handleChange}
            fullWidth
            id='title'
            name='title'
            margin='normal'
            disabled={props.isCommitting}
            label='Campaign Title'
            value={values.title}
          />
          <Field
            component={TextField}
            onChange={handleChange}
            fullWidth
            id='description'
            name='description'
            multiline
            rows={4}
            variant='outlined'
            margin='normal'
            disabled={props.isCommitting}
            label='Description'
            value={values.description}
          />
        </CardContent>
        <Divider />
        <CardContent>
          <Grid container spacing={6} justify='space-between'>
            <Grid item xs md={5}>
              <Field
                component={DiverstDateTimePicker}
                disabled={props.isCommitting}
                required
                keyboardMode
                /* eslint-disable-next-line dot-notation */
                maxDate={touched['end'] ? values['end'] : undefined}
                maxDateMessage='Start date cannot be after end date'
                fullWidth
                id='start'
                name='start'
                margin='normal'
                label='Pick start date and time'
              />
            </Grid>
            <Grid item xs md={5}>
              <Field
                component={DiverstDateTimePicker}
                disabled={props.isCommitting}
                required
                keyboardMode
                /* eslint-disable-next-line dot-notation */
                minDate={values['start']}
                minDateMessage='End date cannot be before start date'
                fullWidth
                id='end'
                name='end'
                margin='normal'
                label='Pick end date and time'
              />
            </Grid>
          </Grid>
          <Divider />
        </CardContent>
        <Divider />
        <CardContent>
          <Field
            component={Select}
            fullWidth
            id='group_ids'
            name='group_ids'
            label='Select Group'
            isMulti
            margin='normal'
            disabled={props.isCommitting}
            value={values.group_ids}
            options={props.selectGroups}
            onMenuOpen={groupSelectAction}
            onChange={value => setFieldValue('group_ids', value)}
            onInputChange={value => groupSelectAction(value)}
            onBlur={() => setFieldTouched('group_ids', true)}
          />
        </CardContent>
        <Divider />
        <CardActions>
          <DiverstSubmit isCommitting={props.isCommitting}>
            {buttonText}
          </DiverstSubmit>
          <Button
            disabled={props.isCommitting}
            to={props.links.campaignsIndex}
            component={WrappedNavLink}
          >
            <DiverstFormattedMessage {...messages.cancel} />
          </Button>
        </CardActions>
      </Form>
    </Card>
  );
}

export function CampaignForm(props) {
  const [defaultStartDate] = useState(DateTime.local().plus({ hour: 1 }));
  const [defaultEndDate] = useState(DateTime.local().plus({ hour: 2 }));

  const initialValues = buildValues(props.campaign, {
    // users: { default: [], customKey: 'member_ids' }
    id: { default: '' },
    title: { default: '' },
    description: { default: '' },
    start: { default: defaultStartDate },
    end: { default: defaultEndDate },
    groups: { default: [], customKey: 'group_ids' },
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        props.createCampaignBegin(mapFields(values, ['group_ids']));
      }}

      render={formikProps => <CampaignFormInner {...props} {...formikProps} />}
    />
  );
}

CampaignForm.propTypes = {
  createCampaignBegin: PropTypes.func,
  group: PropTypes.object,
  groupId: PropTypes.string,
  isCommitting: PropTypes.bool,
};

CampaignFormInner.propTypes = {
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  values: PropTypes.object,
  buttonText: PropTypes.string,
  selectUsers: PropTypes.array,
  selectGroups: PropTypes.array,
  getGroupsBegin: PropTypes.func,
  // getMembersBegin: PropTypes.func,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func,
  touched: PropTypes.object,
  isCommitting: PropTypes.bool,
  links: PropTypes.shape({
    campaignIndex: PropTypes.string
  }),
};

export default compose(
  memo,
)(CampaignForm);
