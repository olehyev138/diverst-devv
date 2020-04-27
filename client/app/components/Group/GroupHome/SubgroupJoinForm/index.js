/**
 *
 * subgroup join Component
 *
 */

import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';
import { Field, Formik, Form } from 'formik';
import { withStyles } from '@material-ui/core/styles';
import { buildValues, mapFields } from 'utils/formHelpers';
import DiverstSwitch from '../../../Shared/DiverstSwitch';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Group/messages';

import {
  Button, Grid, Typography
} from '@material-ui/core';

const styles = theme => ({
  noBottomPadding: {
    paddingBottom: '0 !important',
  },
});

/* eslint-disable object-curly-newline */
export function SubgroupJoinFormInner({ classes, handleSubmit, handleChange, values, handleClose, handleCancel, setFieldValue, ...props }) {
  return (
    <Form>
      <Grid container>
        <Grid item>
          <Typography>{<DiverstFormattedMessage {...messages.joinSubgroups} />}</Typography>
        </Grid>
        {values.children && values.children.map((subgroup, i) => (
          <Grid item key={subgroup.id} xs={12}>
            <Field
              component={DiverstSwitch}
              id='current_user_is_member'
              name='current_user_is_member'
              label={subgroup.name}
              margin='normal'
              value={values.children[i].current_user_is_member}
              onChange={(_, value) => setFieldValue(`children[${i}].current_user_is_member`, value)}
            />
          </Grid>
        ))}
        <Grid item xs='12'>
          <Grid container justify='flex-end'>
            <Button
              color='primary'
              type='submit'
            >
              Update
            </Button>
            <Button onClick={handleCancel}>
              Cancel
            </Button>
          </Grid>
        </Grid>
      </Grid>
    </Form>
  );
}

export function SubgroupJoinForm(props) {
  const initialValues = buildValues(props.group, {
    id: { default: '' },
    name: { default: '' },
    children: { default: [] }
  });

  return (
    <React.Fragment>
      <Formik
        initialValues={initialValues}
        enableReinitialize
        onSubmit={(values, actions) => {
          props.subgroupJoinAction({ group_id: values.id, subgroups: values.children.map(group => ({ group_id: group.id, join: group.current_user_is_member })) });
          props.handleClose();
        }}
      >
        {formikProps => <SubgroupJoinFormInner handleClose={props.handleClose} {...props} {...formikProps} />}
      </Formik>
    </React.Fragment>
  );
}

SubgroupJoinForm.propTypes = {
  handleClose: PropTypes.func,
  subgroupJoinAction: PropTypes.func,
  group: PropTypes.object,
};

SubgroupJoinFormInner.propTypes = {
  handleClose: PropTypes.func,
  classes: PropTypes.object,
  handleSubmit: PropTypes.func,
  handleChange: PropTypes.func,
  values: PropTypes.object,
  setFieldValue: PropTypes.func,
  handleCancel: PropTypes.func,
};

export default compose(
  memo,
  withStyles(styles)
)(SubgroupJoinForm);
