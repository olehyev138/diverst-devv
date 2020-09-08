/**
 *
 * Update Form Component
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import dig from 'object-dig';
import { DateTime } from 'luxon';
import { useParams } from 'react-router-dom';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import { Field, Formik, Form } from 'formik';
import {
  Button, Card, CardActions, CardContent, TextField,
  Divider, Box
} from '@material-ui/core';


import { buildValues } from 'utils/formHelpers';
import messages from 'containers/Shared/Update/messages';

import FieldInputForm from 'components/Shared/Fields/FieldInputForm/Loadable';
import DiverstSubmit from 'components/Shared/DiverstSubmit';
import DiverstCancel from '../../DiverstCancel';
import DiverstFormLoader from 'components/Shared/DiverstFormLoader';
import { DiverstDatePicker } from 'components/Shared/Pickers/DiverstDatePicker';
import { serializeFieldDataWithFieldId } from 'utils/customFieldHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

/* eslint-disable object-curly-newline */
export function UpdateFormInner({ formikProps, buttonText, ...props }) {
  const { handleSubmit, handleChange, handleBlur, values, setFieldValue, setFieldTouched } = formikProps;

  const { group_id: groupId } = useParams();

  return (
    <React.Fragment>
      <DiverstFormLoader isLoading={props.isFetching} isError={props.edit && !props.update}>
        <Form>
          <Card>
            <CardContent>
              <Field
                component={DiverstDatePicker}
                keyboardMode
                fullWidth
                id='report_date'
                name='report_date'
                margin='normal'
                label={<DiverstFormattedMessage {...messages.form.dateOfUpdate} />}
              />
              <Field
                component={TextField}
                onChange={handleChange}
                fullWidth
                disabled={props.isCommitting}
                margin='normal'
                id='comments'
                name='comments'
                value={values.comments}
                label={<DiverstFormattedMessage {...messages.form.comments} />}
              />
            </CardContent>
          </Card>
          <Box mb={2} />
          <Card>
            <FieldInputForm
              fieldData={dig(props, 'update', 'field_data') || []}
              updateFieldDataBegin={props.updateFieldDataBegin}
              isCommitting={props.isCommitting}
              isFetching={props.isFetching}

              messages={messages}
              formikProps={formikProps}
              link={ROUTES.group.plan.kpi.fields.path(groupId)}

              join
              noCard
            />
            <Divider />
            <CardActions>
              <DiverstSubmit isCommitting={props.isCommitting} disabled={(dig(props, 'update', 'field_data') || []).length <= 0}>
                {buttonText}
              </DiverstSubmit>
              <DiverstCancel
                disabled={props.isCommitting}
                redirectFallback={props.links.index}
              >
                <DiverstFormattedMessage {...messages.form.button.cancel} />
              </DiverstCancel>
            </CardActions>
          </Card>
        </Form>
      </DiverstFormLoader>
    </React.Fragment>
  );
}

export function UpdateForm(props) {
  const update = props?.update;

  const initialValues = buildValues(update, {
    report_date: { default: DateTime.local() },
    comments: { default: '' },
    id: { default: '' },
    field_data: { default: [], customKey: 'fieldData' }
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        if (values.fieldData.length !== 0) {
          values.redirectPath = props.links.index;
          const payload = {
            ...values,
            field_data_attributes: serializeFieldDataWithFieldId(values.fieldData)
          };
          delete payload.fieldData;
          props.updateAction(payload);
        }
      }}
    >
      {formikProps => <UpdateFormInner {...props} formikProps={formikProps} />}
    </Formik>
  );
}

UpdateForm.propTypes = {
  updateAction: PropTypes.func.isRequired,
  update: PropTypes.object,
  isCommitting: PropTypes.bool,
  isFetching: PropTypes.bool,
  edit: PropTypes.bool,
  links: PropTypes.shape({
    index: PropTypes.string,
  }).isRequired
};

UpdateFormInner.propTypes = {
  update: PropTypes.object,
  fieldData: PropTypes.array,
  formikProps: PropTypes.object,
  updateFieldDataBegin: PropTypes.func.isRequired,
  buttonText: PropTypes.string.isRequired,
  admin: PropTypes.bool,
  edit: PropTypes.bool,
  isCommitting: PropTypes.bool,
  isFetching: PropTypes.bool,
  links: PropTypes.shape({
    index: PropTypes.string,
  })
};

export default compose(
  memo,
)(UpdateForm);
