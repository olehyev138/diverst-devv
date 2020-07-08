/**
 *
 * Campaign Form Component
 *
 */

import React, { memo, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import {
  Button, Card, CardActions, CardContent, Divider, Grid, TextField
} from '@material-ui/core';
import Select from 'components/Shared/DiverstSelect';
import DiverstDateTimePicker from 'components/Shared/Pickers/DiverstDateTimePicker';
import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { Field, Formik, Form } from 'formik';

import DiverstFormLoader from 'components/Shared/DiverstFormLoader';
import DiverstSubmit from 'components/Shared/DiverstSubmit';

import { buildValues, mapFields } from 'utils/formHelpers';
import { DateTime } from 'luxon';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Innovate/Campaign/messages';

/* eslint-disable object-curly-newline */
export function CampaignFormInner({ handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, touched, ...props }) {
  const { links } = props;
  const groupSelectAction = (searchKey = '') => {
    props.getGroupsBegin({
      count: 10, page: 0, order: 'asc',
      search: searchKey,
    });
  };

  // const getCampaignBeginAction = (searchKey = '') => {
  //   props.getCampaignBegin({
  //     count:
  //   })
  // }

  return (
    <DiverstFormLoader isLoading={props.isFormLoading} isError={props.edit && !props.campaign}>
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
              label={<DiverstFormattedMessage {...messages.Campaign.title} />}
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
              label={<DiverstFormattedMessage {...messages.Campaign.description} />}
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
                  maxDateMessage={<DiverstFormattedMessage {...messages.Campaign.starttimemessage} />}
                  fullWidth
                  id='start'
                  name='start'
                  margin='normal'
                  label={<DiverstFormattedMessage {...messages.Campaign.starttime} />}
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
                  minDateMessage={<DiverstFormattedMessage {...messages.Campaign.endtimemessage} />}
                  fullWidth
                  id='end'
                  name='end'
                  margin='normal'
                  label={<DiverstFormattedMessage {...messages.Campaign.endtime} />}
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
              label={<DiverstFormattedMessage {...messages.Campaign.groups} />}
              isMulti
              margin='normal'
              disabled={props.isCommitting}
              value={values.group_ids}
              options={props.selectGroups}
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
              to={links.CampaignsIndex}
              component={WrappedNavLink}
            >
              <DiverstFormattedMessage {...messages.cancel} />
            </Button>
          </CardActions>
        </Form>
      </Card>
    </DiverstFormLoader>
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
        props.campaignAction(mapFields(values, ['group_ids']));
      }}
    >
      {formikProps => <CampaignFormInner {...props} {...formikProps} />}
    </Formik>
  );
}

CampaignForm.propTypes = {
  edit: PropTypes.bool,
  createCampaignBegin: PropTypes.func,
  group: PropTypes.object,
  groupId: PropTypes.string,
  isCommitting: PropTypes.bool,
  campaign: PropTypes.object,
  campaignAction: PropTypes.func,
};

CampaignFormInner.propTypes = {
  edit: PropTypes.bool,
  campaign: PropTypes.object,
  createCampaignBegin: PropTypes.func,
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
  isFormLoading: PropTypes.bool,
  links: PropTypes.shape({
    campaignsIndex: PropTypes.string
  }),
};

export default compose(
  memo,
)(CampaignForm);
