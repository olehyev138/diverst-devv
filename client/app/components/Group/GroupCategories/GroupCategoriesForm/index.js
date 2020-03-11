/**
 *
 * Group Categories Form Component
 *
 */

import React, { memo } from 'react';
import { Formik, Form, Field, FieldArray } from 'formik';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import { withStyles } from '@material-ui/core/styles';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { ROUTES } from 'containers/Shared/Routes/constants';
import { injectIntl, intlShape } from 'react-intl';
import messages from 'containers/Group/GroupCategories/messages';
import { buildValues } from 'utils/formHelpers';

import {
  Button, Card, CardActions, CardContent, Typography, TextField, Divider,
} from '@material-ui/core';

import DiverstSubmit from 'components/Shared/DiverstSubmit';
import DiverstFormLoader from 'components/Shared/DiverstFormLoader';

const styles = theme => ({
  noBottomPadding: {
    paddingBottom: '0 !important',
  },
});

/* eslint-disable object-curly-newline */
export function GroupCategoriesFormInner({ classes, values, handleChange, buttonText, setFieldValue, setFieldTouched, ...props }) {
  const { intl } = props;
  return (
    // eslint-disable-next-line react/prop-types
    <DiverstFormLoader isLoading={props.isFormLoading} isError={props.edit && !props.groupCategory}>
      <Card>
        <Form>
          <CardContent>
            <Field
              component={TextField}
              onChange={handleChange}
              fullWidth
              disabled={props.isCommitting}
              id='name'
              name='name'
              margin='normal'
              label={intl.formatMessage(messages.name)}
              value={values.name}
              required
            />
            <Typography><DiverstFormattedMessage {...messages.labels} /></Typography>
            <br />
            <FieldArray
              name='group_categories_attributes'
              render={arrayHelpers => (
                <div>
                  {values.group_categories_attributes && values.group_categories_attributes.length > 0 ? values.group_categories_attributes.map((category, index) => (
                    // eslint-disable-next-line react/no-array-index-key
                    <div key={index}>
                      {/* eslint-disable-next-line no-underscore-dangle */}
                      {!values.group_categories_attributes[index]._destroy && (
                        <React.Fragment>
                          <Field name={`group_categories_attributes.${index}.name`} required/>

                          <button
                            type='button'
                            /* eslint-disable-next-line no-unused-expressions */
                            onClick={() => { props.edit ? setFieldValue(`group_categories_attributes[${index}]['_destroy']`, true) : arrayHelpers.remove(index); }} // remove a friend from the list
                          >
                            <DiverstFormattedMessage {...messages.remove} />
                          </button>
                          <button
                            type='button'
                            onClick={() => arrayHelpers.insert(index, {
                              name: '',
                              id: '',
                              _destroy: false
                            })} // insert an empty string at a position
                          >
                            <DiverstFormattedMessage {...messages.add} />
                          </button>
                        </React.Fragment>
                      )}
                    </div>
                  )) : (
                    <button type='button' onClick={() => arrayHelpers.push({ name: '', id: '', _destroy: false })}>
                      <DiverstFormattedMessage {...messages.add_button} />
                    </button>
                  )}
                </div>
              )}
            >
            </FieldArray>
          </CardContent>
          <Divider />
          <CardActions>
            <DiverstSubmit isCommitting={props.isCommitting}>
              {buttonText}
            </DiverstSubmit>
            <Button
              disabled={props.isCommitting}
              to={ROUTES.admin.manage.groups.categories.index.path()}
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

export function GroupCategoriesForm(props) {
  const initialValues = buildValues(props.groupCategory, {
    id: { default: '' },
    name: { default: '' },
    group_categories: { default: [], customKey: 'group_categories_attributes' }
  });

  return (
    <Formik
      initialValues={initialValues}
      enableReinitialize
      onSubmit={(values, actions) => {
        props.groupCategoriesAction(values);
      }}
    >
      {formikProps => <GroupCategoriesFormInner {...props} {...formikProps} />}
    </Formik>
  );
}

GroupCategoriesForm.propTypes = {
  groupCategoriesAction: PropTypes.func,
  groupCategories: PropTypes.array,
  groupCategory: PropTypes.object,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
  categories: PropTypes.array,
  currentUser: PropTypes.object,
  currentEnterprise: PropTypes.object,
};

GroupCategoriesFormInner.propTypes = {
  intl: intlShape,
  groupCategories: PropTypes.array,
  groupCategory: PropTypes.object,
  handleChange: PropTypes.func,
  classes: PropTypes.object,
  values: PropTypes.object,
  buttonText: PropTypes.string,
  categories: PropTypes.array,
  formikProps: PropTypes.object,
  arrayHelpers: PropTypes.object,
  setFieldValue: PropTypes.func,
  setFieldTouched: PropTypes.func,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
};

export default compose(
  injectIntl,
  memo,
  withStyles(styles)
)(GroupCategoriesForm);
