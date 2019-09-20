/**
 *
 * Custom Text Form Component
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import dig from 'object-dig';

import { FormattedMessage } from 'react-intl';
import { Field, Formik, Form } from 'formik';
import {
  Button, Card, CardActions, CardContent, TextField
} from '@material-ui/core';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import messages from 'containers/GlobalSettings/CustomText/messages';
import { buildValues } from 'utils/formHelpers';

/* eslint-disable object-curly-newline */
export function CustomTextFormInner({ handleSubmit, handleChange, handleBlur, values, buttonText, setFieldValue, setFieldTouched, ...props }) {
  return (
    <Card>
      <Form>
        <CardContent>
          <Field
            component={TextField}
            onChange={handleChange}
            fullWidth
            id='erg'
            name='erg'
            label={<FormattedMessage {...messages.erg} />}
            value={values.erg}
          />
          <Field
            component={TextField}
            onChange={handleChange}
            fullWidth
            id='program'
            name='program'
            label={<FormattedMessage {...messages.program} />}
            value={values.program}
          />
          <Field
            component={TextField}
            onChange={handleChange}
            fullWidth
            id='structure'
            name='structure'
            label={<FormattedMessage {...messages.structure} />}
            value={values.structure}
          />
          <Field
            component={TextField}
            onChange={handleChange}
            fullWidth
            id='outcome'
            name='outcome'
            label={<FormattedMessage {...messages.outcome} />}
            value={values.outcome}
          />
          <Field
            component={TextField}
            onChange={handleChange}
            fullWidth
            id='badge'
            name='badge'
            label={<FormattedMessage {...messages.badge} />}
            value={values.badge}
          />
          <Field
            component={TextField}
            onChange={handleChange}
            fullWidth
            id='segment'
            name='segment'
            label={<FormattedMessage {...messages.segment} />}
            value={values.segment}
          />
          <Field
            component={TextField}
            onChange={handleChange}
            fullWidth
            id='dci_full_title'
            name='dci_full_title'
            label={<FormattedMessage {...messages.dci_full_title} />}
            value={values.dci_full_title}
          />
          <Field
            component={TextField}
            onChange={handleChange}
            fullWidth
            id='dci_abbreviation'
            name='dci_abbreviation'
            label={<FormattedMessage {...messages.dci_abbreviation} />}
            value={values.dci_abbreviation}
          />
          <Field
            component={TextField}
            onChange={handleChange}
            fullWidth
            id='member_preference'
            name='member_preference'
            label={<FormattedMessage {...messages.member_preference} />}
            value={values.member_preference}
          />
          <Field
            component={TextField}
            onChange={handleChange}
            fullWidth
            id='parent'
            name='parent'
            label={<FormattedMessage {...messages.parent} />}
            value={values.parent}
          />
          <Field
            component={TextField}
            onChange={handleChange}
            fullWidth
            id='sub_erg'
            name='sub_erg'
            label={<FormattedMessage {...messages.sub_erg} />}
            value={values.sub_erg}
          />
          <Field
            component={TextField}
            onChange={handleChange}
            fullWidth
            id='privacy_statement'
            name='privacy_statement'
            label={<FormattedMessage {...messages.privacy_statement} />}
            value={values.privacy_statement}
          />
        </CardContent>
        <CardActions>
          <Button
            color='primary'
            type='submit'
          >
            {buttonText}
          </Button>
        </CardActions>
      </Form>
    </Card>
  );
}

export function CustomTextForm(props) {
  const customText = dig(props, 'customText');

  const initialValues = buildValues(customText, {
    id: { default: '' },
    erg: { default: 'ERG TEST' },
    program: { default: 'Goal TEST' },
    structure: { default: 'Structure TEST' },
    outcome: { default: 'Focus Area TEST' },
    badge: { default: 'Badge TEST' },
    segment: { default: 'Segment TEST' },
    dci_full_title: { default: 'Engagement TEST' },
    dci_abbreviation: { default: 'Engagement TEST' },
    member_preference: { default: 'Member Survey TEST' },
    parent: { default: 'Parent TEST' },
    sub_erg: { default: 'Sub-Group TEST' },
    privacy_statement: { default: 'Privacy Statement TEST' }
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        props.customTextAction(values);
      }}

      render={formikProps => <CustomTextFormInner {...props} {...formikProps} />}
    />
  );
}

CustomTextForm.propTypes = {
  customTextAction: PropTypes.func,
  customText: PropTypes.object,
  currentUser: PropTypes.object,
  currentGroup: PropTypes.object
};

CustomTextFormInner.propTypes = {
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  handleBlur: PropTypes.func,
  values: PropTypes.object,
  buttonText: PropTypes.string,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func,
  links: PropTypes.shape({
    customTextEdit: PropTypes.string
  })
};

export default compose(
  memo,
)(CustomTextForm);
